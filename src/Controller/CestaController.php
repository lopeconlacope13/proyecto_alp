<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class CestaController extends AbstractController
{
    #[Route('/cesta', name: 'app_cesta')]
    public function index(): Response
    {
        return $this->render('cesta/index.html.twig', [
            'controller_name' => 'CestaController',
        ]);
    }
}
