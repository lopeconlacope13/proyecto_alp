<?php

namespace App\Servcices;

use Symfony\Component\HttpFoundation\RequestStack;
use App\Entity\Producto;


class CestaCompra{
    protected $requestedStack;
    
    protected $productos;
    protected $unidades;


    public function _construct(RequestStack $requestStack){
        $this->requestedStack = $requestStack;
    }
    
    public function cargar_productos($productos, $unidades) {
        
        for($i = 0; $i < count($productos); $i++ ){
            if($unidades[$i] != 0){
                $this->cargar_producto($productos[$i], $unidades[i]);
            }
        }
    }
    
    //Recibe como parámetro el objeto Producto con su unidad
    //Y la carga a la cesta
    public function cargar_producto($producto, $unidad) {
        $this->carga_cesta(); //cargamos la cesta
        //Ahora podemos utilizar los productos y las unidades
        $codigo = $producto->getCodigo();
        //cargamos el código de producto a la cesta
        //si existe el producto, incrementamos las unidades a la cesta
        if(array_key_exists($codigo, $this->productos)){
            //guardamos un array de los códigos de los productos
            $codigos_productos = array_keys($this->productos);
            $posicion = array_search($codigo, $codigos_productos);
            $unidades[$posicion] += $unidad;
            
        }else{
            $productos []=['$codigo' => $producto];
            $unidades[] = [$unidad];
        }
        
        $this->guarda_cesta();
        
    }
    
        protected function carga_cesta() {
        // Guardamos la sesion
        $sesion = $this->requestStack->getSession();
        
        // Si hay productos en la sesión, los cargamos en los atributos del objeto cesta
        if($sesion->has("productos") && $sesion->has("unidades")) {
            $this->productos = $sesion->get("productos");
            $this->unidades =  $sesion->get("unidades");
        } else {
            $this->productos = [];
            $this->unidades = [];
        }
        
        // Creamos un carrito
        $carrito = $sesion->get('carrito');
        
    }
    
    protected function guardar_cesta(){
        $sesion = $this-> requestedStack->getSession();
        
        $sesion->set($this->productos);
        $sesion->set($this->unidades);
    }
    
    
}