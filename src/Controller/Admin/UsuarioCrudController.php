<?php

namespace App\Controller\Admin;

use App\Entity\Usuario;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ArrayField;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Doctrine\ORM\EntityManagerInterface;

class UsuarioCrudController extends AbstractCrudController
{
    // Inyectamos el servicio de cifrado de contraseñas
    public function __construct(
        private UserPasswordHasherInterface $passwordHasher
    ) {}

    public static function getEntityFqcn(): string
    {
        return Usuario::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            IdField::new('id')->hideOnForm(),
            TextField::new('login'),
            TextField::new('email'),
            // Usamos ArrayField para los roles porque es una lista
            ArrayField::new('roles'),
            TextField::new('phone'),
            
            // Campo virtual para la contraseña (solo sale en el formulario)
            TextField::new('plainPassword', 'Contraseña')
                ->setFormType(PasswordType::class)
                ->onlyOnForms()
                ->setRequired($pageName === Crud::PAGE_NEW), // Obligatoria solo al crear nuevo usuario
        ];
    }
    
    // Mantenemos tus filtros
    public function configureFilters(Filters $filters): Filters {
        return $filters
                ->add('login')
                ->add('roles')
                ->add('email')
                ->add('phone');
    }

    // Se ejecuta al CREAR un usuario
    public function persistEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        $this->hashPassword($entityInstance);
        parent::persistEntity($entityManager, $entityInstance);
    }

    // Se ejecuta al EDITAR un usuario
    public function updateEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        $this->hashPassword($entityInstance);
        parent::updateEntity($entityManager, $entityInstance);
    }

    // Nuestra función privada para cifrar la contraseña si es necesario
    private function hashPassword($user): void
    {
        // Si no es un Usuario o no se ha escrito contraseña nueva, salimos
        if (!$user instanceof Usuario || !$user->getPlainPassword()) {
            return;
        }

        // Ciframos la contraseña
        $hashedPassword = $this->passwordHasher->hashPassword(
            $user,
            $user->getPlainPassword()
        );
        
        // La guardamos en el campo real de la base de datos
        $user->setPassword($hashedPassword);
    }
}