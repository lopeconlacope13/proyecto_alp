<?php

namespace App\Services;

use Symfony\Component\HttpFoundation\RequestStack;
use App\Entity\Producto;


class CestaCompra{
    protected $requestedStack;
    protected $productos;
    protected $unidades;


    public function __construct(RequestStack $requestStack){
        $this->requestedStack = $requestStack;
    }
    
    public function cargar_productos($productos, $unidades) {
        
        $this->carga_cesta();
        
        for($i = 0; $i < count($productos); $i++ ){
            if($unidades[$i] != 0){
                $this->cargar_producto($productos[$i], $unidades[i]);
            }
        }
        
        $this->guardar_cesta();
    }
    
    //Recibe como parámetro el objeto Producto con su unidad
    //Y la carga a la cesta
    public function cargar_producto($producto, $unidad) {
        //$this->carga_cesta(); //cargamos la cesta
        //Ahora podemos utilizar los productos y las unidades
        $codigo = $producto->getCodigo();
        //cargamos el código de producto a la cesta
        //si existe el producto, incrementamos las unidades a la cesta
        if(array_key_exists($codigo, $this->productos)){
            //guardamos un array de los códigos de los productos
            //$codigos_productos = array_keys($this->productos);
            //$posicion = array_search($codigo, $codigos_productos);
            $this->unidades[$codigo] += $unidad;
            
            
        }elseif($unidad != 0){
            $this->productos [$codigo]= $producto;
            $this->unidades[$codigo] = $unidad;
        }
        
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
                
    }
    
    protected function guardar_cesta(){
        $sesion = $this-> requestedStack->getSession();
        
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
    
}


