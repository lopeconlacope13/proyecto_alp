<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request; // Importante añadir Request
use Symfony\Component\Routing\Attribute\Route;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\ORM\EntityManagerInterface; // Añadido Interface
use App\Entity\Categoria;
use App\Entity\Producto; // Faltaba importar Producto
use App\Entity\Pedido;
use App\Entity\PedidoProducto;
use App\Services\CestaCompra;

final class BaseController extends AbstractController {
    
    #[Route('/categorias', name: 'categorias')]
    public function mostrar_categorias(ManagerRegistry $em) : Response{
        $categorias = $em->getRepository(Categoria::class)->findAll();
        return $this->render('categorias/mostrar_categorias.html.twig', ['categorias' => $categorias,]);
    }
    
    #[Route('/productos', name: 'productos')]
    public function mostrar_productos(EntityManagerInterface $em, Request $request): Response{
        // Obtenemos el ID desde la query string (?categoria_id=X)
        $categoria_id = $request->query->get('categoria_id') ?? $request->attributes->get('categoria_id');
        
        $objeto_categoria = $em->getRepository(Categoria::class)->find($categoria_id);
        
        if (!$objeto_categoria) {
            return $this->redirectToRoute('categorias');
        }

        $productos = $objeto_categoria->getProductos();
        return $this->render('productos/mostrar_productos.html.twig', ['productos' => $productos]);
    }
    
    #[Route('/anadir', name: 'anadir')]
    public function anadir_productos(EntityManagerInterface $em, Request $request, CestaCompra $cesta){ 
        // Nota: cambié el argumento $cestaCompra a $cesta para que coincida con el código
        
        $productos_id = $request->request->all("productos_id"); // .all() para arrays del formulario
        $unidades = $request->request->all("unidades");

        // Llamada al método personalizado del repositorio (ver punto 4 abajo)
        $productos = $em->getRepository(Producto::class)->findProductosByIds($productos_id);
        
        $cesta->cargar_productos($productos, $unidades);
        
        // Lógica para redirigir a la categoría correcta
        $objetos_producto = array_values($productos);
        $categoria_id = null;
        
        if(count($objetos_producto) > 0) {
             $categoria_id = $objetos_producto[0]->getCategoria()->getId();
        }
        
        if ($categoria_id) {
             // Corregido: sintaxis correcta para pasar parámetros
             return $this->redirectToRoute("productos", ['categoria_id' => $categoria_id]);
        }
        
        return $this->redirectToRoute("categorias");
    }
    
    #[Route('/cesta', name: 'cesta')]
    public function cesta(CestaCompra $cesta){
        return $this->render ('cesta/mostrar_cesta.html.twig', [
            'productos' => $cesta->get_productos(),
            'unidades' => $cesta->get_unidades()            
        ]);
    }
    
    #[Route('/eliminar', name: 'eliminar')]
    public function eliminar(Request $request, CestaCompra $cesta){
        $producto_id = $request->request->get("producto_id");
        $unidades = $request->request->get("unidades");

        $cesta->eliminar_producto($producto_id, $unidades);

        return $this->redirectToRoute('cesta');
    }
    
    #[Route('/pedido', name: 'pedido')]
    public function pedido(EntityManagerInterface $em, CestaCompra $cesta) {
        $error = 0;
        $productos = $cesta->get_productos();
        $unidades = $cesta->get_unidades();

        if (count($productos) == 0) {
            $error = 1;
        } else {
            $pedido = new Pedido();
            $pedido->setCoste($cesta->calcular_coste()); // Corregido: sin argumentos
            $pedido->setFecha(new \DateTime());
            $pedido->setUsuario($this->getUser());
            
            // Generar un código aleatorio si la entidad lo requiere obligatoriamente
            $pedido->setCode(substr(md5(uniqid()), 0, 4)); 

            $em->persist($pedido);

            foreach ($productos as $codigo_producto => $productoCesta) {
                $pedidoProducto = new PedidoProducto();
                $pedidoProducto->setPedido($pedido);
                $pedidoProducto->setProducto($productoCesta);
                $pedidoProducto->setUnidades($unidades[$codigo_producto]);
                $pedidoProducto->setNo("1"); // Valor por defecto para evitar error SQL

                $em->persist($pedidoProducto);
            }

            try {
                $em->flush();
                // Opcional: Vaciar cesta tras pedido exitoso
                // $cesta->vaciar(); 
            } catch (\Exception $ex) { // Corregido: añadir barra invertida
                $error = 2;
            }

            return $this->render('pedido/pedido.html.twig', [
                'pedido_id' => $pedido->getId(),
                'error' => $error,
            ]);
        }
        
        // Renderizar si error es 1
        return $this->render('pedido/pedido.html.twig', [
            'pedido_id' => null,
            'error' => $error,
        ]);
    }
}