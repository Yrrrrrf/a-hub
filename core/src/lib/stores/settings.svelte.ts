// src/lib/stores/settings.svelte.ts
export interface UserPreferences {
    theme: 'light' | 'dark' | 'system';
    notifications: {
        email: boolean;
        push: boolean;
    };
    language: string;
    newsletter: boolean;
}

const defaultPreferences: UserPreferences = {
    theme: 'system',
    notifications: {
        email: true,
        push: false
    },
    language: 'en',
    newsletter: false
};

class ProfileSettingsStore {
    // Initialize state without constructor
    preferences = $state<UserPreferences>(defaultPreferences);

    // Regular methods for updating state
    updatePreferences(newPreferences: Partial<UserPreferences>) {
        this.preferences = { ...this.preferences, ...newPreferences };
        console.log('Preferences updated:', this.preferences);
    }

    updateNotifications(newNotifications: Partial<UserPreferences['notifications']>) {
        this.preferences.notifications = { 
            ...this.preferences.notifications, 
            ...newNotifications 
        };
    }

    toggleTheme() {
        const availableThemes: UserPreferences['theme'][] = ['light', 'dark', 'system'];
        this.preferences.theme = availableThemes[
            (availableThemes.indexOf(this.preferences.theme) + 1) % availableThemes.length
        ];
    }

    toggleEmailNotifications() {
        this.preferences.notifications.email = !this.preferences.notifications.email;
    }

    togglePushNotifications() {
        this.preferences.notifications.push = !this.preferences.notifications.push;
    }

    toggleNewsletter() {
        this.preferences.newsletter = !this.preferences.newsletter;
    }

    reset() {
        this.preferences = defaultPreferences;
    }
}

export const profileSettings = new ProfileSettingsStore();
