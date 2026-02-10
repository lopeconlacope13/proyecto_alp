<?php

namespace App\Repository;

use App\Entity\Producto;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Producto>
 */
class ProductoRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Producto::class);
    }

    /**
     * Busca productos por una lista de IDs
     * Coincide con la llamada del controlador: findProductosByIds
     */
    public function findProductosByIds(array $productos_ids): array 
    {
        // Esta sola línea hace lo mismo que tu bucle foreach, 
        // pero es automático y sin errores de variables.
        return $this->findBy(['id' => $productos_ids]);
    }
}