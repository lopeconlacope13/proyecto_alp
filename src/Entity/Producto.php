<?php

namespace App\Entity;

use App\Repository\ProductoRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ProductoRepository::class)]
class Producto
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $Producto = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getProducto(): ?string
    {
        return $this->Producto;
    }

    public function setProducto(string $Producto): static
    {
        $this->Producto = $Producto;

        return $this;
    }
}
