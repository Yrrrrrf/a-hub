// src/lib/stores/infrastructure.ts
export interface CampusLocation {
    id: string;
    name: string;
    address: string;
    phone: string;
    email: string;
    isMain?: boolean;
}

class InfrastructureStore {
    locations = $state<CampusLocation[]>([
        {
            id: 'main-campus',
            name: 'Main Campus',
            address: '123 University Avenue, Academic City',
            phone: '(555) 123-4567',
            email: 'info@academichub.edu',
            isMain: true
        },
        {
            id: 'downtown-campus',
            name: 'Downtown Campus',
            address: '456 Innovation Street, Tech District',
            phone: '(555) 987-6543',
            email: 'downtown@academichub.edu'
        }
    ]);

    getMainCampus = $derived(
        this.locations.find(location => location.isMain) || this.locations[0]
    );

    getAllCampuses = () => this.locations;
    
    getCampusById = (id: string) => 
        this.locations.find(location => location.id === id);
}

export const infrastructureStore = new InfrastructureStore();