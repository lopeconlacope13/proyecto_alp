<?php

namespace App\Entity;

use App\Repository\PedidoRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
// IMPORTANTE: Estas líneas son necesarias para que funcione la lista de productos
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;

#[ORM\Entity(repositoryClass: PedidoRepository::class)]
class Pedido
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    private ?\DateTimeInterface $fecha = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2)]
    private ?string $coste = null;

    #[ORM\ManyToOne(inversedBy: 'pedidos')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Usuario $usuario = null;

    #[ORM\Column(length: 4)]
    private ?string $code = null;

    #[ORM\OneToMany(mappedBy: 'pedido', targetEntity: PedidoProducto::class, orphanRemoval: true)]
    private Collection $pedidoProductos;

    public function __construct()
    {
        $this->pedidoProductos = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getFecha(): ?\DateTimeInterface
    {
        return $this->fecha;
    }

    public function setFecha(\DateTimeInterface $fecha): static
    {
        $this->fecha = $fecha;

        return $this;
    }

    public function getCoste(): ?string
    {
        return $this->coste;
    }

    public function setCoste(string $coste): static
    {
        $this->coste = $coste;

        return $this;
    }

    public function getUsuario(): ?Usuario
    {
        return $this->usuario;
    }

    public function setUsuario(?Usuario $usuario): static
    {
        $this->usuario = $usuario;

        return $this;
    }

    public function getCode(): ?string
    {
        return $this->code;
    }

    public function setCode(string $code): static
    {
        $this->code = $code;

        return $this;
    }

    public function getPedidoProductos(): Collection
    {
        return $this->pedidoProductos;
    }

    public function addPedidoProducto(PedidoProducto $pedidoProducto): static
    {
        if (!$this->pedidoProductos->contains($pedidoProducto)) {
            $this->pedidoProductos->add($pedidoProducto);
            $pedidoProducto->setPedido($this);
        }

        return $this;
    }

    public function removePedidoProducto(PedidoProducto $pedidoProducto): static
    {
        if ($this->pedidoProductos->removeElement($pedidoProducto)) {
            if ($pedidoProducto->getPedido() === $this) {
                $pedidoProducto->setPedido(null);
            }
        }

        return $this;
    }
}