// src/lib/stores/news.svelte.ts
export interface NewsArticle {
    id: string;
    title: string;
    category: string;
    date: string;
    image: string;
    excerpt: string;
    author: string;
    readTime: string;
    tags?: string[];
}

export interface NewsCategory {
    id: string;
    name: string;
    count: number;
    icon?: string;
}

export interface Event {
    id: string;
    title: string;
    date: string;
    time: string;
    location: string;
    type: string;
}

export interface Announcement {
    id: string;
    title: string;
    date: string;
    priority: 'High' | 'Medium' | 'Normal';
    department: string;
}

class NewsStore {
    // Featured news
    featuredArticle = $state<NewsArticle>({
        id: 'featured-1',
        title: "University Receives Major Research Grant",
        category: "Research",
        date: "March 20, 2024",
        image: 'https://picsum.photos/800/400',
        excerpt: "The Computer Science department has been awarded a $2.5 million grant for advancing AI research in educational technologies.",
        author: "Dr. Sarah Martinez",
        readTime: "5 min read"
    });

    // Categories
    categories = $state<NewsCategory[]>([
        { id: 'cat-1', name: "Academic", count: 15 },
        { id: 'cat-2', name: "Research", count: 12 },
        { id: 'cat-3', name: "Events", count: 8 },
        { id: 'cat-4', name: "Student Life", count: 10 },
        { id: 'cat-5', name: "Faculty", count: 7 },
        { id: 'cat-6', name: "Sports", count: 5 }
    ]);

    // Latest news
    latestNews = $state<NewsArticle[]>([
        {
            id: 'news-1',
            title: "New AI Research Center Opening",
            category: "Research",
            date: "March 19, 2024",
            image: 'https://picsum.photos/800/400',
            excerpt: "State-of-the-art facility to drive innovation in artificial intelligence and machine learning research.",
            author: "Tech Department",
            readTime: "4 min read",
            tags: ["Technology", "Innovation", "Research"]
        },
        {
            id: 'news-2',
            title: "Student Team Wins National Competition",
            category: "Student Life",
            date: "March 18, 2024",
            image: 'https://picsum.photos/800/400',
            excerpt: "Engineering students secure first place in the National Robotics Championship.",
            author: "Student Affairs",
            readTime: "3 min read",
            tags: ["Achievement", "Competition", "Engineering"]
        },
        {
            id: 'news-3',
            title: "New International Partnership Announced",
            category: "Academic",
            date: "March 17, 2024",
            image: 'https://picsum.photos/800/400',
            excerpt: "Partnership with leading European universities opens new opportunities for student exchange.",
            author: "International Relations",
            readTime: "6 min read",
            tags: ["International", "Education", "Partnership"]
        }
    ]);

    // Events
    upcomingEvents = $state<Event[]>([
        {
            id: 'event-1',
            title: "Spring Research Symposium",
            date: "March 25, 2024",
            time: "09:00 AM",
            location: "Main Auditorium",
            type: "Academic"
        },
        {
            id: 'event-2',
            title: "Career Fair 2024",
            date: "March 28, 2024",
            time: "10:00 AM",
            location: "Student Center",
            type: "Career"
        },
        {
            id: 'event-3',
            title: "Tech Innovation Workshop",
            date: "April 2, 2024",
            time: "02:00 PM",
            location: "Tech Lab 101",
            type: "Workshop"
        }
    ]);

    // Announcements
    announcements = $state<Announcement[]>([
        {
            id: 'ann-1',
            title: "Early Registration for Fall 2024",
            date: "March 21, 2024",
            priority: "High",
            department: "Academic Affairs"
        },
        {
            id: 'ann-2',
            title: "Campus Maintenance Schedule",
            date: "March 22, 2024",
            priority: "Medium",
            department: "Facilities"
        },
        {
            id: 'ann-3',
            title: "Library Extended Hours",
            date: "March 23, 2024",
            priority: "Normal",
            department: "Library"
        }
    ]);

    // Search and filter state
    searchQuery = $state('');
    selectedCategory = $state('All');

    // Computed properties
    filteredNews = $derived(
        this.latestNews.filter(article => {
            const matchesSearch = this.searchQuery === '' ||
                article.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                article.excerpt.toLowerCase().includes(this.searchQuery.toLowerCase());
            
            const matchesCategory = this.selectedCategory === 'All' ||
                article.category === this.selectedCategory;
            
            return matchesSearch && matchesCategory;
        })
    );

    // Methods
    setSearchQuery(query: string) {
        this.searchQuery = query;
    }

    setCategory(category: string) {
        this.selectedCategory = category;
    }

    getNewsByCategory(category: string) {
        return this.latestNews.filter(article => article.category === category);
    }

    getEventsByType(type: string) {
        return this.upcomingEvents.filter(event => event.type === type);
    }
}

export const newsStore = new NewsStore();
