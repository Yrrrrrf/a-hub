<script lang="ts">
    import { onMount } from 'svelte';
    import { Sun, Envelope } from 'phosphor-svelte';
    import { authStore } from 'rune-lab';
    import { themeStore } from "rune-lab";
    // import type { AvailableTheme } from "$lib/theme/static.js";

    let loading = $state(true);
    let error = $state<string | null>(null);
    let preferences = $derived(authStore.preferences);

    $effect(() => {
        console.log('Preferences updated:', preferences);
    });

    onMount(() => {
        try {
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
        <!-- Theme Settings -->
        <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
                <h2 class="card-title flex items-center gap-2">
                    <Sun weight="duotone" class="text-primary" />
                    Appearance
                </h2>
                <div class="form-control w-full">
                    <label for="theme" class="label">
                        <span class="label-text">Theme</span>
                    </label>
                    <select
                        id="theme"
                        class="select select-bordered"
                        value={preferences.theme}
                        onchange={(e) => themeStore.setTheme(e.currentTarget.value)}
                    >
                        <!-- <option value="system">System</option> -->
                        {#each themeStore.getAvailableThemes() as theme}
                            <option value={theme.name}>
                                {theme.icon} {theme.name}
                            </option>
                        {/each}
                    </select>
                    {#if preferences.theme !== 'system'}
                        {themeStore.getAvailableThemes().find(t => t.name === preferences.theme)?.description}
                    {/if}
                </div>
            </div>
        </div>

        <!-- Notification Settings -->
        <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
                <h2 class="card-title flex items-center gap-2">
                    <Envelope weight="duotone" class="text-primary" />
                    Notifications
                </h2>
                <div class="form-control">
                    <label class="label cursor-pointer space-x-4">
                        <span class="label-text">Email Notifications</span>
                        <input
                            type="checkbox"
                            class="toggle toggle-primary"
                            checked={preferences.notifications.email}
                            onchange={() => authStore.setPreferences({
                                ...preferences,
                                notifications: {
                                    ...preferences.notifications,
                                    email: !preferences.notifications.email
                                }
                            })}
                        />
                    </label>
                </div>
            </div>
        </div>

        <!-- Language Settings -->
        <div class="card bg-base-100 shadow-lg">
            <div class="card-body">
                <h2 class="card-title">Language</h2>
                <div class="form-control w-full">
                    <label for="language" class="label">
                        <span class="label-text">Select Language</span>
                    </label>
                    <select
                        id="language"
                        class="select select-bordered"
                        value={preferences.language}
                        onchange={(e) =>
                            authStore.setPreferences({ 
                                ...preferences, 
                                language: e.currentTarget.value 
                            })}
                    >
                        <option value="en">English</option>
                        <option value="es">Español</option>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-8 flex justify-end">
        <button 
            class="btn btn-error" 
            onclick={() => authStore.setPreferences({
                theme: 'system',
                language: 'en',
                notifications: { email: true, push: false },
                settings: {}
            })}
        >
            Reset to Defaults
        </button>
    </div>
</div>
{/if}