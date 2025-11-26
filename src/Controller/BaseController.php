<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Runtime\HttpFoundation\Response;
use Symfony\Runtime\Routing\Attribute\Route;
use Doctrine\Persistence\ManagerRegistry;
use App\Entity\Categoria;

final class BaseController extends AbstractController{
    #[Route('/categorias', name: 'categorias')]
    public function mostrar_categorias(ManagerRegistry $em) : Response{
        $categorias = $em->getRepository(Categoria::class)->findAll();
        return $this->render('categorias/mostrar_categorias.html.twig', ['categorias' => $categorias,]);
    }
    
    #[Route('/productos', name: 'productos')]
    public function mostrar_productos(EntityManagerInterface $em, int $categoria_id) : Response{
        $objeto_categoria = $em->getRepository(Categoria::class)->find($categoria_id);
        $productos = $objeto_categoria->getProductos();
        return $this->render('productos/mostrar_productos.html.twig', ['productos' => $productos,]);
    }
    
    
    #[Route('/anadir', name: 'anadir')]
    public function anadir_productos(EntityManagerInterface $em, Request $request, CestaCompra $cestaCompra){
        //recogemos los datos de entrada
        $productos_id = $request->request->get("productos_id");
        $unidades = $request->request->get("unidades");
        $productos = $em->getRepository(Producto::class) -> findProductosByIds();
        
        //Llamamos a cargaproductos para añadirlos a la cesta con sus unidades
        $cesta->cargar_productos($productos, $unidades);
        return $this->redirectToRoute("productos", ['categoria'=>$productos->get]);

    }
    
    
}

