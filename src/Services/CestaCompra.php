<?php

namespace App\Services;

use App\Entity\Producto;
use Symfony\Component\HttpFoundation\RequestStack;

class CestaCompra {
    protected $requestStack; // Corregido el nombre
    protected $productos = []; // Inicializar como array
    protected $unidades = [];  // Inicializar como array

    public function __construct(RequestStack $requestStack) {
        $this->requestStack = $requestStack;
    }
    
    public function cargar_productos($productos, $unidades) {
        $this->carga_cesta();
        
        // Convertimos a valores de array para asegurar que los índices coincidan (0, 1, 2...)
        $productos = array_values($productos);
        $unidades = array_values($unidades);

        for($i = 0; $i < count($productos); $i++ ){
            // AÑADIDO: Comprobación isset y el símbolo '$' antes de la 'i'
            if(isset($unidades[$i]) && $unidades[$i] != 0){
                $this->cargar_producto($productos[$i], $unidades[$i]);
            }
        }
        $this->guardar_cesta();
    }
    
    public function cargar_producto(Producto $producto, $unidad) {
        $codigo = $producto->getCodigo();
        
        if(array_key_exists($codigo, $this->productos)){
            $this->unidades[$codigo] += $unidad;
        } elseif($unidad != 0) {
            $this->productos[$codigo] = $producto;
            $this->unidades[$codigo] = $unidad;
        }
    }
    
    protected function carga_cesta() {
        $sesion = $this->requestStack->getSession();
        
        if($sesion->has("productos") && $sesion->has("unidades")) {
            $this->productos = $sesion->get("productos");
            $this->unidades =  $sesion->get("unidades");
        } else {
            $this->productos = [];
            $this->unidades = [];
        }
    }
    
    protected function guardar_cesta(){
        $sesion = $this->requestStack->getSession();
        $sesion->set('productos', $this->productos);
        $sesion->set('unidades', $this->unidades);
    }

    public function get_productos() {
        $this->carga_cesta();
        return $this->productos;
    }
    
    public function get_unidades(){
        $this->carga_cesta();
        return $this->unidades;
    }
    
    public function eliminar_producto($codigo_producto, $unidades_a_restar){
        $this->carga_cesta();
        
        if(array_key_exists($codigo_producto, $this->productos)){
            // CORREGIDO: Faltaba el símbolo '$' en codigo_producto
            $this->unidades[$codigo_producto] -= $unidades_a_restar;
            
            // Si las unidades son 0 o menos, borramos el producto totalmente
            if($this->unidades[$codigo_producto] <= 0){
                unset($this->unidades[$codigo_producto]);
                unset($this->productos[$codigo_producto]);
            }
            $this->guardar_cesta();
        }
    }
    
    // CORREGIDO: Eliminados los argumentos, usa las propiedades de la clase
    public function calcular_coste() {
        $this->carga_cesta();
        $resultado = 0;
        foreach ($this->productos as $codigo_producto => $producto){
            $resultado += $producto->getPrecio() * $this->unidades[$codigo_producto];
        }
        return $resultado;
    }
}