; Ebene duplizieren -> Farben -> Komponenten -> Komponente extrahieren -> LAB L
; Kanäle -> beliebigen Kanal nach unten ziehen -> umbenennen "L"
; alles markieren -> Kontextmenü L -> Kanäle von Auswahl abziehen
; Auswahl -> In Kanal speichern -> "D"
; Kontextmenü L -> Kanäle von Auswahl abziehen -> Auswahl -> In Kanal speichern -> "DD"
; Kontextmenü L -> Kanäle von Auswahl abziehen -> Auswahl -> In Kanal speichern -> "DDD"
; Auswahl "nichts" -> Kontextmenü L -> Auswahl aus Kanal
; Kontextmenü D -> Kanäle von Auswahl abziehen -> Auswahl -> In Kanal speichern -> "LL"
; Kontextmenü D -> Kanäle von Auswahl abziehen -> Auswahl -> In Kanal speichern -> "LLL"
; Auswahl "nichts" -> Kontextmenü L -> Auswahl aus Kanal
; Kontextmenü D -> Schnittmenge zwischen Kanälen und Auswahl -> Auswahl -> In Kanal speichern -> "M"

(script-fu-register-filter "script-fu-gestreift-opt-lumimask"
	_"opt. Luminance Masks"
	"Creates precise L-D-M zone masks based on LAB L."
	"Andreas"
	"andreas@gestreift.net"
	"April 2026"
	"*" 
	SF-ONE-DRAWABLE
)

(script-fu-menu-register "script-fu-gestreift-opt-lumimask" "<Image>/Filters/gestreift.net")

(define (add-layer-with-selection-mask image drawable parent name pos)
	(let* 	(
			(new-layer (gimp-layer-copy drawable FALSE))
			(new-mask  (gimp-layer-create-mask new-layer ADD-MASK-SELECTION))
		)
		(gimp-image-insert-layer image new-layer parent pos)
		(gimp-item-set-name new-layer name)
		(gimp-layer-add-mask new-layer new-mask)

		; return new layer, just in case
		new-layer
	)
)

(define (script-fu-gestreift-opt-lumimask image drawables)
	(script-fu-use-v3)
	(gimp-image-undo-group-start image)
	(gimp-context-push)
    
	; Setup: Force colours (white foreground, black background)
	(gimp-context-set-foreground '(255 255 255))
	(gimp-context-set-background '(0 0 0))

	(let* (
		(drawable (vector-ref drawables 0))
		(parent   (gimp-item-get-parent drawable))
		; Temp. layer for the extraction of LAB-L
		(base-layer (gimp-layer-new-from-visible image image "temp. base")) 
		(lumi-layer (gimp-layer-new-from-visible image image "temp. lumi"))
		(lumi-group (gimp-group-layer-new image "Luminance Masks"))
		)

		(gimp-image-insert-layer image lumi-group 0 0)
        
		(gimp-image-insert-layer image base-layer parent -1)
		(gimp-image-insert-layer image lumi-layer parent -1)
		(gimp-drawable-desaturate lumi-layer DESATURATE-LUMINANCE)

		; --- KANAL L (Basis-Lichter) ---
		(let 	((chan-L (gimp-channel-new-from-component image 3 "L"))) ; 3 = GRAY
			(gimp-image-insert-channel image chan-L 0 0)
			(gimp-image-select-item image CHANNEL-OP-REPLACE chan-L)
			(add-layer-with-selection-mask image base-layer lumi-group "L" -1)

			(let 	((chan-D (gimp-channel-copy chan-L)))
				(gimp-item-set-name chan-D "D")
				(gimp-image-insert-channel image chan-D 0 0)
				(gimp-drawable-fill chan-D 1) ; 1 = BACKGROUND (black)
				(gimp-image-select-item image CHANNEL-OP-REPLACE chan-L)
				(gimp-selection-invert image)
				(gimp-drawable-edit-fill chan-D 0) ; 0 = FOREGROUND (white)

				(gimp-selection-all image)
				(gimp-image-select-item image CHANNEL-OP-SUBTRACT chan-L) 
				(add-layer-with-selection-mask image base-layer lumi-group "D" -1)

				(gimp-image-select-item image CHANNEL-OP-SUBTRACT chan-L)
				(add-layer-with-selection-mask image base-layer lumi-group "DD" -1)

				(gimp-image-select-item image CHANNEL-OP-SUBTRACT chan-L)
				(add-layer-with-selection-mask image base-layer lumi-group "DDD" -1)

				(gimp-image-select-item image CHANNEL-OP-REPLACE chan-L)
				(gimp-image-select-item image CHANNEL-OP-INTERSECT chan-D)
				(add-layer-with-selection-mask image base-layer lumi-group "M" 3)

				(gimp-image-select-item image CHANNEL-OP-REPLACE chan-L)
				(gimp-image-select-item image CHANNEL-OP-SUBTRACT chan-D)
				(add-layer-with-selection-mask image base-layer lumi-group "LL" 5)

				(gimp-image-select-item image CHANNEL-OP-SUBTRACT chan-D)
				(add-layer-with-selection-mask image base-layer lumi-group "LLL" 6)
			)
		)
	
		; clean-up
		(gimp-image-remove-layer image lumi-layer)
		(gimp-image-remove-layer image base-layer)
		(gimp-selection-none image)
	)

	(gimp-context-pop)
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
)
