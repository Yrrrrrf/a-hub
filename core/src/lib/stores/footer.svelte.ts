import { footerStore } from "rune-lab";

export function initFooter() {
    footerStore
        .init({
            sections: [
                {
                    title: "Product",
                    links: [
                        // { text: "Features", href: "/features" },  // Internal route
                        { text: "API Docs", href: "http://localhost:8000/docs" },  // External link
                        { text: "OpenAPI", href: "http://localhost:8000/openapi.json" },  // External link
                        // { text: "Pricing", href: "/pricing" }  // Internal route
                    ]
                },
                {
                    title: "Company",
                    links: [
                        { text: "About", href: "/about" },
                        { text: "Careers", href: "/academic" },
                        { text: "Contact", href: "/contact" },
                        { text: "Blog", href: "/news" },
                    ]
                },
                {
                    title: "Resources",
                    links: [
                        { text: "Community", href: "/community" },
                        { text: "Help Center", href: "/help" },
                        { text: "Status", href: "/status" },
                        { text: "Terms", href: "/terms" }
                    ]
                }
            ]
        })
        .showSocialLinks(true)
        .updateSocialLinks({
            github: "https://github.com/Yrrrrrf/a-hub",
            twitter: "https://twitter.com",
            linkedin: "https://linkedin.com"
        })
        // .showVersion(true)
        .showCopyright(true)
    ;
}