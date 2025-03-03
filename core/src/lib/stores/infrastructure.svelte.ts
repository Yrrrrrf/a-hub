import {
	Buildings,
	MapPin,
	Clock,
	Info,
	Users,
	BookOpen,
	Coffee,
	Laptop,
	Trophy,
	Chalkboard
} from 'phosphor-svelte';

export interface CampusLocation {
	id: string;
	name: string;
	address: string;
	phone: string;
	email: string;
	isMain?: boolean;
	image?: string;
	totalFloors?: number;
	facilities?: string[];
	accessibility?: boolean;
	description?: string;
}

export interface FacilityType {
	icon: any; // Using 'any' for now, you can replace it with a more specific type if you have one
	name: string;
	count: number;
}

export interface CampusStat {
	icon: any;
	value: string;
	label: string;
}

export interface Update {
	icon: any;
	facility: string;
	update: string;
	date: string;
}

class InfrastructureStore {
	locations = $state<CampusLocation[]>([
		{
			id: 'main-campus',
			name: 'Main Academic Building',
			address: 'Central Campus, Block A',
			phone: '(555) 123-4567',
			email: 'info@academichub.edu',
			isMain: true,
			image: 'https://picsum.photos/400/300',
			totalFloors: 5,
			facilities: ['Classrooms', 'Offices', 'Computer Labs'],
			accessibility: true,
			description: 'Primary academic facility housing multiple departments and lecture halls'
		},
		{
			id: 'science-complex',
			name: 'Science Complex',
			address: 'North Campus, Research Park',
			phone: '(555) 987-6543',
			email: 'science@academichub.edu',
			image: 'https://picsum.photos/400/300',
			totalFloors: 4,
			facilities: ['Laboratories', 'Research Centers', 'Study Areas'],
			accessibility: true,
			description: 'State-of-the-art research and laboratory complex'
		},
		{
			id: 'engineering-center',
			name: 'Engineering Center',
			address: 'East Campus, Tech Quarter',
			phone: '(555) 555-1212',
			email: 'engineering@academichub.edu',
			image: 'https://picsum.photos/400/300',
			totalFloors: 6,
			facilities: ['Workshops', 'Labs', 'Project Spaces'],
			accessibility: true,
			description: 'Advanced engineering facilities and workshops'
		},
		{
			id: 'student-center',
			name: 'Student Center',
			address: 'Central Campus, Student Zone',
			phone: '(555) 789-0123',
			email: 'studentcenter@academichub.edu',
			image: 'https://picsum.photos/400/300',
			totalFloors: 3,
			facilities: ['Cafeteria', 'Study Rooms', 'Recreation Areas'],
			accessibility: true,
			description: 'Hub for student activities and services'
		}
	]);

	// Facility Types
	facilityTypes = $state<FacilityType[]>([
		{ icon: BookOpen, name: 'Classrooms', count: 120 },
		{ icon: Laptop, name: 'Laboratories', count: 45 },
		{ icon: Buildings, name: 'Libraries', count: 3 },
		{ icon: Coffee, name: 'Cafeterias', count: 5 },
		{ icon: Chalkboard, name: 'Sports Facilities', count: 8 }
	]);

	// Campus Stats
	campusStats = $state<CampusStat[]>([
		{ icon: MapPin, value: '250,000', label: 'Square Meters' },
		{ icon: Users, value: '15,000', label: 'Daily Visitors' },
		{ icon: Buildings, value: '300+', label: 'Rooms' },
		{ icon: Trophy, value: '50+', label: 'Facilities' }
	]);

	// Latest Renovations/Updates
	latestUpdates = $state<Update[]>([
		{
			facility: 'Computer Lab 3A',
			update: 'New Equipment Installation',
			date: 'March 2024',
			icon: Laptop
		},
		{
			facility: 'Library West Wing',
			update: 'Study Space Expansion',
			date: 'February 2024',
			icon: BookOpen
		},
		{
			facility: 'Science Labs',
			update: 'Safety System Upgrade',
			date: 'January 2024',
			icon: Info
		}
	]);

	getMainCampus = $derived(this.locations.find((location) => location.isMain) || this.locations[0]);

	getAllCampuses = () => this.locations;

	getCampusById = (id: string) => this.locations.find((location) => location.id === id);

	getFacilityTypes = () => this.facilityTypes;

	getCampusStats = () => this.campusStats;

	getLatestUpdates = () => this.latestUpdates;
}

export const infrastructureStore = new InfrastructureStore();