<?php

namespace App\Controller;

// 1. Importamos las clases que vamos a necesitar
use App\Repository\CategoriaRepository; // Para poder hablar con la tabla 'categoria'
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted; // Para proteger el controlador

/**
 * Este atributo protege TODAS las rutas definidas en este controlador.
 * Solo permitirá el acceso a usuarios que tengan el 'ROLE_USER',
 * es decir, que hayan iniciado sesión.
 */
#[IsGranted('ROLE_USER')]
final class CategoriasController extends AbstractController
{
    /**
     * Esta función (método) maneja la ruta /categorias.
     * Symfony es lo bastante listo como para ver que pides un "CategoriaRepository"
     * como argumento, y te lo "inyecta" automáticamente.
     */
    #[Route('/categorias', name: 'categorias')]
    public function index(CategoriaRepository $categoriaRepository): Response
    {
        // 1. Usamos el repositorio para pedirle TODOS los registros de la tabla 'categoria'.
        // Esto es el "findAll()" que menciona el documento.
        $categorias = $categoriaRepository->findAll();

        // 2. Renderizamos (dibujamos) la plantilla Twig.
        // Le pasamos un array con la variable 'categorias' para que la plantilla
       
        return $this->render('categorias/index.html.twig', [
            'categorias' => $categorias,
        ]);
    }
}