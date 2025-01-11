<script lang="ts">
    import { profileSettings } from '$lib/stores/settings.svelte';
    import { onMount } from 'svelte';
    import {
        Sun, Moon, Bell, BellSlash, Envelope, At
    } from 'phosphor-svelte';

    let loading = $state(true);
    let error = $state<string | null>(null);
    let preferences = $derived(profileSettings.preferences);

    $effect(() => {
        console.log('Preferences updated:', preferences);
    });

    onMount(() => {
        try {
            // Add a small delay to ensure store is ready
            setTimeout(() => {
                loading = false;
            }, 500);
        } catch (e) {
            error = 'Failed to load preferences';
            loading = false;
        }
    });
</script>

{#if error}
    <div class="alert alert-error">
        <span>{error}</span>
    </div>
{:else if loading}
    <div class="flex justify-center p-8">
        <span class="loading loading-spinner loading-lg"></span>
    </div>
{:else}

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-6">Profile Settings</h1>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
                <h2 class="card-title flex items-center gap-2">
                    <Sun weight="duotone" class="text-primary" />
                    Appearance
                </h2>
                <div class="form-control w-full max-w-xs">
                    <label for="theme" class="label">
                        <span class="label-text">Theme</span>
                    </label>
                    <select
                        id="theme"
                        class="select select-bordered"
                        value={preferences.theme}
                        onchange={(e) =>
                            profileSettings.updatePreferences({ theme: e.currentTarget.value as 'light' | 'dark' | 'system' })}
                    >
                        <option value="light">Light</option>
                        <option value="dark">Dark</option>
                        <option value="system">System</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
                <h2 class="card-title flex items-center gap-2">
                    <Bell weight="duotone" class="text-primary" />
                    Notifications
                </h2>
                <div class="form-control">
                    <label class="label cursor-pointer space-x-4">
                        <span class="label-text flex items-center gap-2">
                            <Envelope class="w-4 h-4" /> Email Notifications
                        </span>
                        <input
                            type="checkbox"
                            class="toggle toggle-primary"
                            checked={preferences.notifications.email}
                            onchange={() => profileSettings.toggleEmailNotifications()}
                        />
                    </label>
                </div>
                <div class="form-control">
                    <label class="label cursor-pointer space-x-4">
                        <span class="label-text flex items-center gap-2">
                            <BellSlash class="w-4 h-4" /> Push Notifications
                        </span>
                        <input
                            type="checkbox"
                            class="toggle toggle-primary"
                            checked={preferences.notifications.push}
                            onchange={() => profileSettings.togglePushNotifications()}
                            disabled
                        />
                    </label>
                    <div class="text-sm opacity-70">Push notifications are not available at this time.</div>
                </div>
                <div class="form-control">
                    <label class="label cursor-pointer space-x-4">
                        <span class="label-text flex items-center gap-2">
                            <At class="w-4 h-4" /> Newsletter
                        </span>
                        <input
                            type="checkbox"
                            class="toggle"
                            checked={preferences.newsletter}
                            onchange={() => profileSettings.toggleNewsletter()}
                        />
                    </label>
                </div>
            </div>
        </div>

        <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
                <h2 class="card-title">Language</h2>
                <div class="form-control w-full max-w-xs">
                    <label for="language" class="label">
                        <span class="label-text">Select Language</span>
                    </label>
                    <select
                        id="language"
                        class="select select-bordered"
                        value={preferences.language}
                        onchange={(e) =>
                            profileSettings.updatePreferences({ language: e.currentTarget.value })}
                    >
                        <option value="en">English</option>
                        <option value="es">Español</option>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div class="mt-8 flex justify-end">
        <button class="btn btn-error" onclick={() => profileSettings.reset()}>
            Reset to Defaults
        </button>
    </div>
</div>
{/if}
