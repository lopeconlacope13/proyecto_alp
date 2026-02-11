<?php
namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\ORM\EntityManagerInterface;
use App\Entity\Categoria;
use App\Entity\Usuario;
use App\Entity\Producto;
use App\Entity\Pedido;
use App\Entity\PedidoProducto;
use App\Services\CestaCompra;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\Mime\Address;
use Symfony\Component\Security\Http\Attribute\IsGranted;

    
/**
 * Controlador principal de la tienda.
 * Gestiona el catálogo, la cesta de la compra y el proceso de pedido.
 */
#[IsGranted('ROLE_USER')]
final class BaseController extends AbstractController {


    /**
     * Muestra el listado de todas las categorías disponibles en la tienda.
     * * @Route("/categorias", name="categorias")
     */
    #[Route('/categorias', name: 'categorias')]
    public function mostrar_categorias(ManagerRegistry $em): Response {
        // Consultamos todas las categorías en base de datos
        $categorias = $em->getRepository(Categoria::class)->findAll();
        
        return $this->render('categorias/mostrar_categorias.html.twig', [
            'categorias' => $categorias,
        ]);
    }

    /**
     * Muestra los productos asociados a una categoría específica.
     * * @param int $categoria_id El ID de la categoría a visualizar
     * @Route("/productos/{categoria_id}", name="productos")
     */
    #[Route('/productos/{categoria_id}', name: 'productos')]
    public function mostrar_productos(EntityManagerInterface $em, int $categoria_id): Response {
        // Buscamos la categoría. Si no existe, redirigimos.
        $objeto_categoria = $em->getRepository(Categoria::class)->find($categoria_id);

        if (!$objeto_categoria) {
            return $this->redirectToRoute('categorias');
        }

        // Obtenemos los productos de la categoría (Lazy Loading)
        $productos = $objeto_categoria->getProductos();
        
        return $this->render('productos/mostrar_productos.html.twig', [
            'productos' => $productos,
            'categoria' => $objeto_categoria
        ]);
    }

    /**
     * Procesa el formulario para añadir productos a la cesta.
     * Recibe los IDs y las unidades y delega en el servicio CestaCompra.
     * * @Route("/anadir", name="anadir")
     */
    #[Route('/anadir', name: 'anadir')]
    public function anadir_productos(EntityManagerInterface $em, Request $request, CestaCompra $cesta) {
        // Recogida de datos del Request (Formulario)
        $productos_id = $request->request->all("productos_id");
        $unidades = $request->request->all("unidades");

        // Buscamos los objetos Producto completos
        $productos = $em->getRepository(Producto::class)->findProductosByIds($productos_id);

        // Llamada al servicio para guardar en sesión
        $cesta->cargar_productos($productos, $unidades);

        // Lógica para redirigir al usuario a la misma categoría donde estaba
        $objetos_producto = array_values($productos);
        $categoria_id = null;

        if (count($objetos_producto) > 0) {
            $categoria_id = $objetos_producto[0]->getCategoria()->getId();
        }

        if ($categoria_id) {
            return $this->redirectToRoute("productos", ['categoria_id' => $categoria_id]);
        }

        return $this->redirectToRoute("categorias");
    }

    /**
     * Muestra el contenido actual de la cesta de la compra.
     * * @Route("/cesta", name="cesta")
     */
    #[Route('/cesta', name: 'cesta')]
    public function cesta(CestaCompra $cesta) {
        return $this->render('cesta/mostrar_cesta.html.twig', [
            'productos' => $cesta->get_productos(),
            'unidades' => $cesta->get_unidades()
        ]);
    }

    /**
     * Elimina un producto específico de la cesta de la compra.
     * * @Route("/eliminar", name="eliminar")
     */
    #[Route('/eliminar', name: 'eliminar')]
    public function eliminar(Request $request, CestaCompra $cesta) {
        $producto_id = $request->request->get("producto_id");
        $unidades = $request->request->get("unidades");

        $cesta->eliminar_producto($producto_id, $unidades);

        return $this->redirectToRoute('cesta');
    }

    /**
     * Finaliza la compra: Guarda el pedido en BD y envía el correo de confirmación.
     * * @Route("/pedido", name="pedido")
     */
    #[Route('/pedido', name: 'pedido')]
    public function pedido(EntityManagerInterface $em, CestaCompra $cesta, MailerInterface $mailer) {
        $error = 0;
        $productos = $cesta->get_productos();
        $unidades = $cesta->get_unidades();

        // Validación de cesta vacía
        if (count($productos) == 0) {
            $error = 1;
        } else {
            // 1. Creación del objeto Pedido
            $pedido = new Pedido();
            $pedido->setCoste($cesta->calcular_coste());
            $pedido->setFecha(new \DateTime());
            $pedido->setUsuario($this->getUser());
            $pedido->setCode(substr(md5(uniqid()), 0, 4));

            $em->persist($pedido);

            // 2. Creación de las líneas de pedido (PedidoProducto)
            foreach ($productos as $codigo_producto => $productoCesta) {
                
                $pedidoProducto = new PedidoProducto();
                $pedidoProducto->setPedido($pedido);
                
                // Usamos getReference para optimizar la carga y evitar conflictos de sesión
                $productoRef = $em->getReference(Producto::class, $productoCesta->getId());
                $pedidoProducto->setProducto($productoRef);
                
                $pedidoProducto->setUnidades($unidades[$codigo_producto]);
                $pedidoProducto->setNo("1");

                $em->persist($pedidoProducto);
            }

            try {
                // 3. Volcado a la base de datos (Transacción)
                $em->flush();
                
                // 4. Configuración y envío del Email
                // Usamos las direcciones fijas solicitadas para pruebas
                $remitente = 'alopper2510@g.educaand.es';
                $destinatario = 'paco.taquito.paco@gmail.com';

                if ($destinatario) {
                    $email = (new TemplatedEmail())
                        ->from($remitente)
                        ->to(new Address($destinatario))
                        ->subject('Confirmación de pedido #' . $pedido->getId())
                        ->htmlTemplate('correo.html.twig')
                        ->context([
                            'pedido_id' => $pedido->getId(), 
                            'productos' => $productos, 
                            'unidades' => $unidades,
                            'coste' => $cesta->calcular_coste(),
                        ]);
                    
                    $mailer->send($email);
                }

            } catch (\Exception $ex) { 
                // Error durante el guardado o envío de email
                $error = 2;
            }

            // Renderizamos la vista de confirmación
            return $this->render('pedido/pedido.html.twig', [
                'pedido_id' => $pedido->getId(),
                'error' => $error,
            ]);
        }

        // Renderizado en caso de error (cesta vacía)
        return $this->render('pedido/pedido.html.twig', [
            'pedido_id' => null,
            'error' => $error,
        ]);
    }

    /**
     * Muestra el historial de pedidos del usuario conectado.
     * Lista los pedidos ordenados por fecha descendente con sus detalles.
     * * @Route("/pedidos", name="pedidos")
     */
    #[Route('/pedidos', name: 'pedidos')]
    public function pedidos(EntityManagerInterface $em): Response {
        $usuario = $this->getUser();

        // Si el usuario no está logueado, redirigimos al login
        // CORREGIDO: Redirigimos a 'login' en vez de 'app_login'
        //if (!$usuario) {
        //    return $this->redirectToRoute('login');
        //}

        // Consulta personalizada usando el repositorio
        // Ordenamos por fecha DESC para ver los más recientes primero
        $pedidos = $em->getRepository(Pedido::class)->findBy(
            ['usuario' => $usuario], 
            ['fecha' => 'DESC']
        );

        return $this->render('pedido/pedidos.html.twig', [
            'pedidos' => $pedidos
        ]);
    }
}