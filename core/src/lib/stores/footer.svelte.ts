import { footerStore } from "rune-lab";

export function initFooter() {
    footerStore
        .init({
            sections: [
                {
                    title: "Product",
                    links: [
                        { text: "API Docs", href: "http://3.88.132.195:8000/docs" },  // External link
                        { text: "OpenAPI", href: "http://3.88.132.195:8000/openapi.json" },  // External link
                        // { text: "Features", href: "/features" },  // Internal route
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
                        { text: "Status", href: "/profile/manage" },
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
