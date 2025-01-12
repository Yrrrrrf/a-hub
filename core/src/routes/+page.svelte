<!-- src/routes/+page.svelte -->
<script lang="ts">
  import { goto } from '$app/navigation';
  import { 
      GraduationCap, 
      Users, 
      Books,
      Student,
      Chalkboard,
      Buildings,
      EnvelopeSimple,
      Phone,

      CheckCircle,

      ArrowRight,

      Calendar



  } from 'phosphor-svelte';
  
  import { infrastructureStore } from '$lib/stores/infrastructure.svelte';
  import { academicStatsStore } from '$lib/stores/academic-stats.svelte';

  // Academic features showcase using runes
  let academicFeatures = $state([
      { 
          icon: Books, 
          title: 'Academic Excellence', 
          description: 'Comprehensive academic programs designed for success' 
      },
      { 
          icon: Student, 
          title: 'Student Success', 
          description: 'Supporting student achievement through innovative resources' 
      },
      { 
          icon: Chalkboard, 
          title: 'Modern Learning', 
          description: 'State-of-the-art facilities and teaching methodologies' 
      }
  ]);

  // Core modules with runes
  let coreModules = $state([
      { 
          title: 'Academic Programs', 
          description: 'Diverse range of undergraduate and graduate programs',
          icon: GraduationCap
      },
      { 
          title: 'Research Centers', 
          description: 'Advanced research facilities and opportunities',
          icon: Books
      },
      { 
          title: 'Student Services', 
          description: 'Comprehensive support for student success',
          icon: Users
      },
      { 
          title: 'Campus Life', 
          description: 'Rich cultural and educational experiences',
          icon: Buildings
      }
  ]);

  // Get main campus information
  let mainCampus = $derived(infrastructureStore.getMainCampus);
  let stats = $derived(academicStatsStore.getStats());
</script>

<div class="min-h-screen bg-base-200">
    <!-- Hero Section -->
        <section 
            class="hero min-h-[80vh] relative bg-gradient-to-br from-primary/10 to-base-200 bg-cover bg-center" 
            style="background-image: url({'/vitrum.jpg'});">
        <div class="hero-overlay bg-black/30 backdrop-blur-sm"></div> <!-- Optional overlay -->
        <div class="hero-content text-center relative z-10">
            <div class="max-w-4xl">
                <h1 class="text-6xl font-bold mb-4">Welcome to Academic Hub</h1>
                <h2 class="text-3xl font-bold text-primary mb-8">
                    Shaping Tomorrow's Leaders
                </h2>
                <p class="text-xl mb-8 max-w-2xl mx-auto">
                    Discover a world-class education experience that combines academic excellence,
                    innovative research, and a vibrant campus community.
                </p>
                <div class="flex gap-4 justify-center">
                    <button class="btn btn-primary btn-lg" 
                        onclick={() => goto('/about')}>
                        <GraduationCap weight="bold" class="w-5 h-5 mr-2" />
                        About Us
                    </button>
                    <button class="btn btn-outline btn-lg"
                        onclick={() => goto('/news')}>
                        Latest Updates
                    </button>
                </div>
            </div>
        </div>
    </section>

    Features Section
    <section class="py-20 container mx-auto px-4">
        <h2 class="text-4xl font-bold text-center mb-16">Why Choose Us</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            {#each academicFeatures as feature}
                <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300">
                    <div class="card-body items-center text-center">
                        <feature.icon class="w-16 h-16 text-primary mb-6" />
                        <h3 class="card-title text-2xl mb-4">{feature.title}</h3>
                        <p class="text-base-content/80 text-lg">{feature.description}</p>
                    </div>
                </div>
            {/each}
        </div>
    </section>

  <!-- Statistics Section -->
  <section class="bg-primary text-primary-content py-20">
      <div class="container mx-auto px-4">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
              {#each stats as stat}
                  <div class="stat p-4 transform hover:scale-105 transition-transform">
                      <div class="stat-value text-5xl font-bold mb-4">
                          {stat.value}
                      </div>
                      <div class="stat-label text-xl opacity-90">
                          {stat.label}
                      </div>
                  </div>
              {/each}
          </div>
      </div>
  </section>

<!-- Quick Links Section -->
<!-- <section class="py-16 -mt-20 relative z-20 container mx-auto px-4">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {#each quickLinks as link}
            <div 
                class="card bg-base-100 shadow-2xl hover:shadow-xl transition-all duration-300 
                       hover:-translate-y-1 group backdrop-blur-sm"
            >
                <div class="card-body">
                    <div class="relative overflow-hidden rounded-xl mb-4">
                        <div class="absolute inset-0 bg-primary/10 transition-transform duration-500
                                  group-hover:scale-110"></div>
                        <link.icon 
                            weight="duotone"
                            class="w-12 h-12 text-primary relative z-10 transition-transform 
                                   group-hover:scale-110 group-hover:rotate-12" 
                        />
                    </div>
                    <h3 class="card-title text-xl mb-2">{link.title}</h3>
                    <p class="text-base-content/70">{link.description}</p>
                    <div class="card-actions justify-end mt-4">
                        <a 
                            href={link.href} 
                            class="text-primary hover:text-primary-focus transition-colors duration-300
                                   inline-flex items-center gap-2 text-sm font-medium"
                        >
                            Explore
                            <ArrowRight class="w-4 h-4 transform group-hover:translate-x-1 transition-transform" />
                        </a>
                    </div>
                </div>
            </div>
        {/each}
    </div>
</section> -->

<!-- Stats Section -->
<!-- <section class="py-20 bg-primary text-primary-content relative overflow-hidden"> -->
    <!-- Decorative Background -->
    <!-- <div class="absolute inset-0 grid grid-cols-8 gap-4 opacity-5" aria-hidden="true">
        {#each Array(32) as _}
            <div class="aspect-square border border-current rotate-45 transform hover:scale-110 transition-transform"></div>
        {/each}
    </div>

    <div class="container mx-auto px-4 relative z-10">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
            {#each stats as stat}
                <div class="group perspective">
                    <div class="stat p-6 bg-primary-content/10 backdrop-blur-sm rounded-box 
                              transform hover:scale-105 transition-all duration-300
                              hover:shadow-xl group-hover:bg-primary-content/20">
                        <div class="flex items-center justify-center mb-4">
                            <stat.icon 
                                weight="duotone"
                                class="w-12 h-12 opacity-80 transform group-hover:rotate-12 
                                       transition-transform duration-300" 
                            />
                        </div>
                        <div class="stat-value text-4xl font-bold mb-2 text-center">
                            {stat.value}
                        </div>
                        <div class="stat-label text-lg opacity-90 text-center">
                            {stat.label}
                        </div>
                        {#if stat.trend}
                            <div class="stat-desc text-success text-center mt-2">
                                ↗︎ {stat.trend.value} ({stat.trend.direction})
                            </div>
                        {/if}
                    </div>
                </div>
            {/each}
        </div>
    </div>
</section> -->

<!-- Featured Programs -->
<!-- <section class="py-20 bg-base-100">
    <div class="container mx-auto px-4">
        <h2 class="text-4xl font-bold text-center mb-6">Featured Programs</h2>
        <p class="text-xl opacity-80 max-w-2xl mx-auto text-center mb-16">
            Explore our comprehensive range of academic programs designed to prepare you
            for success in your chosen field.
        </p>

        <div class="w-full overflow-x-auto hide-scrollbar pb-8">
            <div class="flex gap-6 min-w-max p-4">
                {#each featuredPrograms as program}
                    <div class="w-[400px] group perspective">
                        <div class="card bg-base-200 shadow-xl hover:shadow-2xl transition-all duration-500
                                  hover:-translate-y-2 relative overflow-hidden">
                            <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent 
                                      opacity-0 group-hover:opacity-100 transition-opacity"></div>
                            <div class="card-body">
                                <div class="flex justify-between items-start mb-4">
                                    <program.icon 
                                        weight="duotone"
                                        class="w-12 h-12 text-primary transform group-hover:scale-110 
                                               group-hover:rotate-12 transition-all duration-300" 
                                    />
                                    <div class="badge badge-primary">{program.code}</div>
                                </div>
                                <h3 class="card-title text-xl mb-2">{program.name}</h3>
                                <p class="text-base-content/70 mb-4">{program.description}</p>
                                <div class="space-y-2">
                                    {#each program.highlights as highlight}
                                        <div class="flex items-center gap-2">
                                            <CheckCircle weight="fill" class="w-4 h-4 text-success" />
                                            <span>{highlight}</span>
                                        </div>
                                    {/each}
                                </div>
                                <div class="card-actions justify-end mt-4">
                                    <a 
                                        href="/academic/programs/{program.id}"
                                        class="btn btn-primary btn-sm gap-2"
                                    >
                                        Learn More
                                        <ArrowRight class="w-4 h-4" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    </div>
</section> -->

<!-- News & Events -->
<!-- <section class="py-20 bg-base-200">
    <div class="container mx-auto px-4">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold mb-4">Latest Updates</h2>
            <p class="text-xl opacity-80 max-w-2xl mx-auto">
                Stay informed about our latest news, events, and achievements.
            </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            {#each latestUpdates as update}
                <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all 
                           duration-300 group hover:-translate-y-1">
                    <figure class="relative aspect-video overflow-hidden">
                        <img 
                            src={update.image} 
                            alt={update.title}
                            class="w-full h-full object-cover transition-transform duration-500
                                   group-hover:scale-110" 
                        />
                        <div class="absolute top-4 right-4">
                            <div class="badge badge-primary">{update.category}</div>
                        </div>
                    </figure>
                    <div class="card-body">
                        <div class="flex items-center gap-2 text-sm opacity-70 mb-2">
                            <Calendar weight="fill" class="w-4 h-4" />
                            {update.date}
                        </div>
                        <h3 class="card-title text-lg hover:text-primary transition-colors">
                            {update.title}
                        </h3>
                        <p class="text-base-content/70">{update.excerpt}</p>
                        <div class="card-actions justify-end mt-4">
                            <a 
                                href={update.link} 
                                class="text-primary hover:text-primary-focus transition-colors 
                                       inline-flex items-center gap-2"
                            >
                                Read More
                                <ArrowRight class="w-4 h-4 transform group-hover:translate-x-1
                                                 transition-transform" />
                            </a>
                        </div>
                    </div>
                </div>
            {/each}
        </div>
    </div>
</section> -->

<!-- Campus Life
<section class="py-20 bg-base-100 relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-br from-primary/5 to-transparent opacity-50"></div>
    <div class="container mx-auto px-4 relative z-10">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
            <div class="space-y-8">
                <h2 class="text-4xl font-bold">Campus Life</h2>
                <p class="text-xl opacity-80">
                    Experience a vibrant campus community with state-of-the-art facilities
                    and endless opportunities for growth and development.
                </p>
                <div class="grid grid-cols-2 gap-4">
                    {#each campusFeatures as feature}
                        <div class="card bg-base-200 hover:bg-base-300 transition-colors p-4">
                            <feature.icon 
                                weight="duotone"
                                class="w-8 h-8 text-primary mb-2" 
                            />
                            <h3 class="font-bold mb-1">{feature.title}</h3>
                            <p class="text-sm opacity-70">{feature.description}</p>
                        </div>
                    {/each}
                </div>
                <div class="flex gap-4">
                    <button class="btn btn-primary">
                        Virtual Tour
                        <Buildings class="w-4 h-4" />
                    </button>
                    <button class="btn btn-outline">
                        Learn More
                        <ArrowRight class="w-4 h-4" />
                    </button>
                </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
                {#each campusImages as image, i}
                    <div 
                        class="aspect-square rounded-xl overflow-hidden shadow-xl hover:shadow-2xl
                               transition-all hover:-translate-y-2 hover:translate-x-2"
                        style="transform: rotate({i * 3}deg)"
                    >
                        <img 
                            src={image.url} 
                            alt={image.alt}
                            class="w-full h-full object-cover" 
                        />
                    </div>
                {/each}
            </div>
        </div>
    </div>
</section> -->

<style>
    .hide-scrollbar {
        scrollbar-width: none;
        -ms-overflow-style: none;
        scroll-behavior: smooth;
    }
    .hide-scrollbar::-webkit-scrollbar {
        display: none;
    }
    .perspective {
        perspective: 1000px;
    }
</style>

</div>
