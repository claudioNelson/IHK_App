"use client";

import { useEffect } from "react";

interface ImageLightboxProps {
    src: string;
    alt: string;
    onClose: () => void;
}

export default function ImageLightbox({ src, alt, onClose }: ImageLightboxProps) {
    // ESC-Taste schließt Lightbox
    useEffect(() => {
        const handleKey = (e: KeyboardEvent) => {
            if (e.key === "Escape") onClose();
        };
        document.addEventListener("keydown", handleKey);
        // Body-Scroll sperren während Lightbox offen
        const prevOverflow = document.body.style.overflow;
        document.body.style.overflow = "hidden";
        return () => {
            document.removeEventListener("keydown", handleKey);
            document.body.style.overflow = prevOverflow;
        };
    }, [onClose]);

    return (
        <div
            className="lb-backdrop"
            onClick={onClose}
            role="dialog"
            aria-modal="true"
            aria-label={alt}
        >
            <style>{`
                .lb-backdrop {
                    position: fixed;
                    inset: 0;
                    z-index: 9999;
                    background: rgba(10, 10, 15, 0.85);
                    backdrop-filter: blur(8px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 40px;
                    cursor: zoom-out;
                    animation: lb-fade-in 0.15s ease-out;
                }
                .lb-image {
                    max-width: 100%;
                    max-height: 100%;
                    object-fit: contain;
                    border-radius: 8px;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
                    cursor: default;
                }
                .lb-close {
                    position: absolute;
                    top: 20px;
                    right: 20px;
                    width: 40px;
                    height: 40px;
                    border-radius: 20px;
                    background: rgba(255, 255, 255, 0.1);
                    border: 1px solid rgba(255, 255, 255, 0.2);
                    color: #FFFFFF;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 18px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: background 0.15s;
                }
                .lb-close:hover {
                    background: rgba(255, 255, 255, 0.2);
                }
                .lb-hint {
                    position: absolute;
                    bottom: 20px;
                    left: 50%;
                    transform: translateX(-50%);
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: rgba(255, 255, 255, 0.6);
                    letter-spacing: 1px;
                    text-transform: uppercase;
                }
                @keyframes lb-fade-in {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
            `}</style>

            <button
                className="lb-close"
                onClick={onClose}
                aria-label="Schließen"
            >
                ✕
            </button>

            <img
                src={src}
                alt={alt}
                className="lb-image"
                onClick={(e) => e.stopPropagation()}
            />

            <div className="lb-hint">ESC oder Klick außerhalb zum Schließen</div>
        </div>
    );
}