(define memories
  '(
    (memory Vector
      (address (#x0000 . #x03ff)))

    (memory flash
      (address (#xe00000 . #xe3ffff))
      (type ROM)
      (section (startup #xe00000))
      (section text rodata))

    (memory dataRAM
      (address (#x400 . #x37ffff))
      (type RAM)
      (section bss))

    (block stack (size #x1000))

    (block sstack (size #x200))

    (block heap (size #x0000))
  )
)