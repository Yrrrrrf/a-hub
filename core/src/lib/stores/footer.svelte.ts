import {  footerStore } from 'rune-lab';


export function initFooter() {
    footerStore
        .init({
            sections: [
                {
                    title: "Product",
                    links: [
                        { text: "Features", href: "/features" },
                        { text: "Docs", href: "/docs" },
                        { text: "API", href: "/api" },
                        { text: "Pricing", href: "/pricing" }
                    ]
                },
                {
                    title: "Company",
                    links: [
                        { text: "About", href: "/about" },
                        { text: "Blog", href: "/blog" },
                        { text: "Careers", href: "/careers" },
                        { text: "Contact", href: "/contact" }
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
            github: "https://github.com/Yrrrrrf",
            twitter: "https://twitter.com",
            linkedin: "https://linkedin.com"
        })
        .showVersion(true)
        .showCopyright(true)
    ;
}
