import {
	BookOpen,
	Clock,
	Users,
	Archive,
	GraduationCap,
	MagnifyingGlass,
	BookmarkSimple
} from 'phosphor-svelte';

// Interfaces
interface Book {
	title: string;
	author: string;
	cover?: string;
	category: string;
	rating: number;
}

interface Category {
	name: string;
	count: number;
}

interface LibraryStat {
	icon: any;
	value: string;
	label: string;
}

interface Service {
	icon: any;
	title: string;
	description: string;
}

class LibraryStore {
	// Featured new arrivals
	newArrivals = $state<Book[]>([
		{
			title: 'Advanced Database Systems',
			author: 'Catherine Johnson, Ph.D.',
			cover: '/placeholder.jpg',
			category: 'Computer Science',
			rating: 4.8
		},
		{
			title: 'Modern Physics: Quantum Mechanics',
			author: 'Robert Chen',
			cover: '/placeholder.jpg',
			category: 'Physics',
			rating: 4.9
		},
		{
			title: 'Biomedical Engineering Principles',
			author: 'Sarah Williams',
			cover: '/placeholder.jpg',
			category: 'Engineering',
			rating: 4.7
		},
		{
			title: 'Machine Learning Applications',
			author: 'David Martinez',
			cover: '/placeholder.jpg',
			category: 'Artificial Intelligence',
			rating: 4.9
		}
	]);

	// Popular categories
	categories = $state<Category[]>([
		{ name: 'Computer Science', count: 2500 },
		{ name: 'Engineering', count: 3200 },
		{ name: 'Mathematics', count: 1800 },
		{ name: 'Physics', count: 1500 },
		{ name: 'Chemistry', count: 1300 },
		{ name: 'Biology', count: 1600 }
	]);

	// Library stats
	libraryStats = $state<LibraryStat[]>([
		{ icon: BookOpen, value: '50,000+', label: 'Books' },
		{ icon: Users, value: '10,000+', label: 'Active Readers' },
		{ icon: BookmarkSimple, value: '1,000+', label: 'E-Journals' },
		{ icon: Archive, value: '100+', label: 'Databases' }
	]);

	// Library services
	services = $state<Service[]>([
		{
			icon: MagnifyingGlass,
			title: 'Advanced Search',
			description: 'Powerful search tools to find exactly what you need'
		},
		{
			icon: Clock,
			title: '24/7 Access',
			description: 'Access digital resources anytime, anywhere'
		},
		{
			icon: BookOpen,
			title: 'Resource Reservation',
			description: 'Reserve books and study rooms in advance'
		},
		{
			icon: GraduationCap,
			title: 'Research Support',
			description: 'Expert librarians to assist with research'
		}
	]);

	// Methods to get data
	getNewArrivals = () => this.newArrivals;
	getCategories = () => this.categories;
	getLibraryStats = () => this.libraryStats;
	getServices = () => this.services;
}

export const libraryStore = new LibraryStore();