// src/lib/stores/contact.svelte.ts
import { Phone, Envelope, MapPin, Buildings } from 'phosphor-svelte';

export interface ContactPerson {
    id: string;
    name: string;
    title: string;
    department: string;
    extension: string;
    phone: string;
    email?: string;
    image?: string;
    role: 'director' | 'coordinator' | 'staff';
}

export interface Department {
    id: string;
    name: string;
    description: string;
    location: string;
    contacts: ContactPerson[];
}

export interface ContactInfo {
    phone: string;
    email: string;
    address: string;
    socialMedia: {
        facebook?: string;
        twitter?: string;
        instagram?: string;
        linkedin?: string;
    };
}

class ContactStore {
    // Main contact information
    mainInfo = $state<ContactInfo>({
        phone: '+52 (722) 214 08 55',
        email: 'contacto@uaemex.mx',
        address: 'Instituto Literario 100, Centro, Toluca, Estado de México',
        socialMedia: {
            facebook: 'https://www.facebook.com/UAEMex',
            twitter: 'https://twitter.com/UAEMex',
            instagram: 'https://www.instagram.com/uaemex',
            linkedin: 'https://www.linkedin.com/school/uaemex'
        }
    });

    // Main director
    director = $state<ContactPerson>({
        id: 'dir-001',
        name: 'Dr. Marcelo Romero Huertas',
        title: 'Director',
        department: 'Dirección',
        extension: '1002',
        phone: '+52 (722) 214 08 55',
        image: '/directors/marcelo-romero.jpg',
        role: 'director'
    });

    // Departments and their contacts
    departments = $state<Department[]>([
        {
            id: 'dep-1',
            name: 'Coordinación de Ingeniería Civil',
            description: 'Coordinación del programa de Ingeniería Civil',
            location: 'Edificio A, Planta Alta',
            contacts: [
                {
                    id: 'civ-001',
                    name: 'Dra. Ma. de Lourdes Nájera López',
                    title: 'Coordinadora',
                    department: 'Ingeniería Civil',
                    extension: '1013',
                    phone: '+52 (722) 214 08 55',
                    role: 'coordinator'
                }
            ]
        },
        {
            id: 'dep-2',
            name: 'Coordinación de Ingeniería en Computación',
            description: 'Coordinación del programa de Ingeniería en Computación',
            location: 'Edificio B, Planta Baja',
            contacts: [
                {
                    id: 'comp-001',
                    name: 'Dra. Carolina Álvarez Ramilla',
                    title: 'Coordinadora',
                    department: 'Ingeniería en Computación',
                    extension: '1016',
                    phone: '+52 (722) 214 08 55',
                    role: 'coordinator'
                }
            ]
        },
        {
            id: 'dep-difcult',
            name: 'Coordinación de Difusión Cultural',
            description: 'Coordinación de actividades culturales',
            location: 'Edificio Principal',
            contacts: [{
                id: 'dif-001',
                name: 'Ing. Jorge Valente García Velázquez',
                title: 'Coordinador',
                department: 'Difusión Cultural',
                extension: '1017',
                phone: '+52 (722) 214 08 55',
                role: 'coordinator'
            }]
        },
        {
            id: 'dep-control',
            name: 'Departamento de Control Escolar',
            description: 'Gestión de documentación y control escolar',
            location: 'Edificio Administrativo',
            contacts: [{
                id: 'ctrl-001',
                name: 'Mtra. Guadalupe Rodríguez Camacho',
                title: 'Jefa del Departamento',
                department: 'Control Escolar',
                extension: '1076',
                phone: '+52 (722) 214 08 55',
                role: 'coordinator'
            }]
        },
        {
            id: 'dep-educ',
            name: 'Departamento de Educación Continua y a Distancia',
            description: 'Coordinación de programas de educación continua',
            location: 'Edificio de Posgrado',
            contacts: [{
                id: 'educ-001',
                name: 'M. en A. P. David Álvarez Reséndez',
                title: 'Jefe del Departamento',
                department: 'Educación Continua y a Distancia',
                extension: '1098',
                phone: '+52 (722) 214 08 55',
                role: 'coordinator'
            }]
        },
        {
            id: 'dep-eval',
            name: 'Departamento de Evaluación Profesional',
            description: 'Gestión de procesos de evaluación profesional',
            location: 'Edificio Administrativo',
            contacts: [{
                id: 'eval-001',
                name: 'M. en C.A. Eduardo Trujillo Flores',
                title: 'Jefe del Departamento',
                department: 'Evaluación Profesional',
                extension: '1068',
                phone: '+52 (722) 214 08 55',
                role: 'coordinator'
            }]
        },
        {
            id: 'dep-invest',
            name: 'Coordinación del Centro de Investigación en Ingeniería Estructural',
            description: 'Centro de investigación especializado',
            location: 'Centro de Investigación',
            contacts: [{
                id: 'inv-001',
                name: 'Dr. Horacio Ramírez de Alba',
                title: 'Coordinador',
                department: 'Centro de Investigación en Ingeniería Estructural',
                extension: '1095',
                phone: '+52 (722) 214 08 55',
                role: 'coordinator'
            }]
        }
        // Add more departments as needed
    ]);

    // Quick contact buttons
    quickContacts = $state([
        { icon: Phone, label: 'Llamar', value: '+52 (722) 214 08 55', action: 'tel:+527222140855' },
        { icon: Envelope, label: 'Email', value: 'contacto@uaemex.mx', action: 'mailto:contacto@uaemex.mx' },
        { icon: MapPin, label: 'Ubicación', value: 'Toluca, México', action: 'https://maps.app.goo.gl/7sW3CFyrBGdqrgfY6' },
        { icon: Buildings, label: 'Facultad', value: 'FI UAEMex', action: '/about' }
    ]);

    // Methods to get filtered contacts
    getDirectors = () => this.departments
        .flatMap(d => d.contacts)
        .filter(c => c.role === 'director');

    getCoordinators = () => this.departments
        .flatMap(d => d.contacts)
        .filter(c => c.role === 'coordinator');

    getDepartmentContacts = (depId: string) => 
        this.departments.find(d => d.id === depId)?.contacts || [];

    searchContacts = (query: string) => {
        const searchTerm = query.toLowerCase();
        return this.departments.flatMap(d => d.contacts)
            .filter(c => 
                c.name.toLowerCase().includes(searchTerm) ||
                c.department.toLowerCase().includes(searchTerm) ||
                c.title.toLowerCase().includes(searchTerm)
            );
    };
}

export const contactStore = new ContactStore();
