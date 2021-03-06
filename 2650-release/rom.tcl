#==============================================================================
# ========================
# rom.tcl - the PIPBUG ROM
# ========================

# Copyright 2005 (C) Peter Linich

set ROM	{
		{ 0000 07 3f		}
		{ 0002 20		}
		{ 0003 cf 44 00		}
		{ 0006 5b 7b		}
		{ 0008 04 77		}
		{ 000a cc 04 09		}
		{ 000d 04 1b		}
		{ 000f cc 04 0b		}
		{ 0012 04 80		}
		{ 0014 cc 04 0c 	}
		{ 0017 1b 09		}
		{ 0019 01 60		}
		{ 001b 01 6e		}

		{ 001d 04 3f		}
		{ 001f 3f 02 b4		}
		{ 0022 75 ff		}
		{ 0024 3f 00 8a		}
		{ 0027 04 2a		}
		{ 0029 3f 02 b4		}
		{ 002c 3b 2d		}
		{ 002e 20		}
		{ 002f cc 04 27		}
		{ 0032 0c 04 13		}
		{ 0035 e4 41		}
		{ 0037 1c 00 ab		}
		{ 003a e4 42		}
		{ 003c 1c 01 e5		}
		{ 003f e4 43		}
		{ 0041 1c 01 ca		}
		{ 0044 e4 44		}
		{ 0046 1c 03 10		}
		{ 0049 e4 47		}
		{ 004b 1c 01 3a		}
		{ 004e e4 4c		}
		{ 0050 1c 03 b5		}
		{ 0053 e4 53		}
		{ 0055 1c 00 f4		}
		{ 0058 1f 00 1d		}

		{ 005b 07 ff		}
		{ 005d cf 04 27		}
		{ 0060 e7 14		}
		{ 0062 18 19		}
		{ 0064 3f 02 86		}
		{ 0067 e4 7f		}
		{ 0069 98 0e		}
		{ 006b e7 ff		}
		{ 006d 18 71		}
		{ 006f 0f 64 13		}
		{ 0072 3f 02 b4		}
		{ 0075 a7 01		}
		{ 0077 1b 67		}
		{ 0079 e4 0d		}
		{ 007b 98 18		}
		{ 007d 05 01		}
		{ 007f 03		}
		{ 0080 1a 02		}
		{ 0082 85 02		}
		{ 0084 cd 04 2a		}
		{ 0087 cf 04 29		}
		{ 008a 04 0d		}
		{ 008c 3f 02 b4		}
		{ 008f 04 0a		}
		{ 0091 3f 02 b4		}
		{ 0094 17		}

		{ 0095 05 02		}
		{ 0097 e4 0a		}
		{ 0099 18 64		}
		{ 009b cf 24 13		}
		{ 009e 3f 02 b4		}
		{ 00a1 1f 00 60		}

		{ 00a4 cd 04 0d		}
		{ 00a7 ce 04 0e		}
		{ 00aa 17		}

		{ 00ab 3f 02 db		}
		{ 00ae 3b 74		}
		{ 00b0 3f 02 69		}
		{ 00b3 0d 04 0e		}
		{ 00b6 3f 02 69		}
		{ 00b9 3f 03 5b		}
		{ 00bc 0d 84 0d		}
		{ 00bf 3f 02 69		}
		{ 00c2 3f 03 5b		}
		{ 00c5 3f 00 5b		}
		{ 00c8 0c 04 2a		}
		{ 00cb e4 02		}
		{ 00cd 1e 00 22		}
		{ 00d0 18 11		}
		{ 00d2 cc 04 11		}
		{ 00d5 3f 02 db		}
		{ 00d8 ce 84 0d		}
		{ 00db 0c 04 11		}
		{ 00de e4 04		}
		{ 00e0 9c 00 22		}
		{ 00e3 06 01		}
		{ 00e5 8e 04 0e		}
		{ 00e8 05 00		}
		{ 00ea 77 08		}
		{ 00ec 8d 04 0d		}
		{ 00ef 75 08		}
		{ 00f1 1f 00 ae		}

		{ 00f4 3f 02 db		}
		{ 00f7 e6 08		}
		{ 00f9 1d 00 1d		}
		{ 00fc ce 04 11		}
		{ 00ff 0e 64 00		}
		{ 0102 c1		}
		{ 0103 3f 02 69		}
		{ 0106 3f 03 5b		}
		{ 0109 3f 00 5b		}
		{ 010c 0c 04 2a		}
		{ 010f e4 02		}
		{ 0111 1e 00 22		}
		{ 0114 18 1c		}
		{ 0116 cc 04 0f		}
		{ 0119 3f 02 db		}
		{ 011c 02		}
		{ 011d 0e 04 11		}
		{ 0120 ce 64 00		}
		{ 0123 e6 08		}
		{ 0125 98 03		}
		{ 0127 cc 04 0a		}
		{ 012a 0c 04 0f		}
		{ 012d e4 03		}
		{ 012f 1c 00 22		}
		{ 0132 0e 04 11		}
		{ 0135 86 01		}
		{ 0137 1f 00 f7		}

		{ 013a 3f 02 db		}
		{ 013d 3f 00 a4		}
		{ 0140 0c 04 07		}
		{ 0143 92		}
		{ 0144 0d 04 01		}
		{ 0147 0e 04 02		}
		{ 014a 0f 04 03		}
		{ 014d 77 10		}
		{ 014f 0d 04 04		}
		{ 0152 0e 04 05		}
		{ 0155 0f 04 06		}
		{ 0158 0c 04 00		}
		{ 015b 75 ff		}
		{ 015d 1f 04 09		}

		{ 0160 cc 04 00		}
		{ 0163 13		}
		{ 0164 cc 04 08		}
		{ 0167 cc 04 0a		}
		{ 016a 04 00		}
		{ 016c 1b 0c		}
		{ 016e cc 04 00		}
		{ 0171 13		}
		{ 0172 cc 04 08		}
		{ 0175 cc 04 0a		}
		{ 0178 04 01		}
		{ 017a cc 04 11		}
		{ 017d 12		}
		{ 017e cc 04 07		}
		{ 0181 77 10		}
		{ 0183 cd 04 04		}
		{ 0186 ce 04 05		}
		{ 0189 cf 04 06		}
		{ 018c 75 10		}
		{ 018e cd 04 01		}
		{ 0191 ce 04 02		}
		{ 0194 cf 04 03		}
		{ 0197 0e 04 11		}
		{ 019a 3b 0f		}
		{ 019c 0d 04 0d		}
		{ 019f 3f 02 69		}
		{ 01a2 0d 04 0e		}
		{ 01a5 3f 02 69		}
		{ 01a8 1f 00 22		}

		{ 01ab 20		}
		{ 01ac ce 64 2d		}
		{ 01af 0e 64 33		}
		{ 01b2 cc 04 0d		}
		{ 01b5 0e 64 35		}
		{ 01b8 cc 04 0e		}
		{ 01bb 0e 64 2f		}
		{ 01be cc 84 0d		}
		{ 01c1 0e 64 31		}
		{ 01c4 07 01		}
		{ 01c6 cf e4 0d		}
		{ 01c9 17		}

		{ 01ca 3b 0b		}
		{ 01cc 0e 64 2d		}
		{ 01cf 1c 00 1d		}
		{ 01d2 3b 57		}
		{ 01d4 1f 00 22		}
		{ 01d7 3f 02 db		}
		{ 01da a6 01		}
		{ 01dc 1e 02 50		}
		{ 01df e6 01		}
		{ 01e1 1d 02 50		}
		{ 01e4 17		}
		{ 01e5 3b 70		}
		{ 01e7 0e 64 2d		}
		{ 01ea bc 01 ab		}
		{ 01ed ce 04 11		}
		{ 01f0 3f 02 db		}
		{ 01f3 3f 00 a4		}
		{ 01f6 0f 04 11		}
		{ 01f9 02		}
		{ 01fa cf 64 35		}
		{ 01fd 01		}
		{ 01fe cf 64 33		}
		{ 0201 0c 84 0d		}
		{ 0204 cf 64 2f		}
		{ 0207 05 9b		}
		{ 0209 cd 84 0d		}
		{ 020c 06 01		}
		{ 020e 0e e4 0d		}
		{ 0211 cf 64 31		}
		{ 0214 0f 62 22		}
		{ 0217 ce e4 0d		}
		{ 021a 04 ff		}
		{ 021c cf 64 2d		}
		{ 021f 1f 00 22		}

		{ 0222 99		}
		{ 0223 9b		}

		{ 0224 3f 02 86		}
		{ 0227 3b 1d		}
		{ 0229 d3		}
		{ 022a d3		}
		{ 022b d3		}
		{ 022c d3		}
		{ 022d cf 04 12		}
		{ 0230 3f 02 86		}
		{ 0233 3b 11		}
		{ 0235 6f 04 12		}
		{ 0238 03		}
		{ 0239 c1		}
		{ 023a 3b 01		}
		{ 023c 17		}

		{ 023d 01		}
		{ 023e 2c 04 2c		}
		{ 0241 d0		}
		{ 0242 cc 04 2c		}
		{ 0245 17		}

		{ 0246 07 10		}
		{ 0248 ef 42 59		}
		{ 024b 14		}
		{ 024c e7 01		}
		{ 024e 9a 78		}

		{ 0250 0c 04 07		}
		{ 0253 64 40		}
		{ 0255 12		}
		{ 0256 1f 00 1d		}

		{ 0259 30 31 32 33	}
		{ 025d 34 35 36 37	}
		{ 0261 38 39 41 42	}
		{ 0265 43 44 45 46	}

		{ 0269 cd 04 12		}
		{ 026c 3b 4f		}
		{ 026e 51		}
		{ 026f 51		}
		{ 0270 51		}
		{ 0271 51		}
		{ 0272 45 0f		}
		{ 0274 0d 62 59		}
		{ 0277 3f 02 b4		}
		{ 027a 0d 04 12		}
		{ 027d 45 0f		}
		{ 027f 0d 62 59		}
		{ 0282 3f 02 b4		}
		{ 0285 17		}

		{ 0286 54 01		}
		{ 0288 17		}
		{ 0289 40		}
		{ 028a 40		}
		{ 028b 40		}
		{ 028c 40		}
		{ 028d 40		}
		{ 028e 40		}
		{ 028f 40		}
		{ 0290 40		}
		{ 0291 40		}
		{ 0292 40		}
		{ 0293 40		}
		{ 0294 40		}
		{ 0295 40		}
		{ 0296 40		}
		{ 0297 40		}
		{ 0298 40		}
		{ 0299 40		}
		{ 029a 40		}
		{ 029b 40		}
		{ 029c 40		}
		{ 029d 40		}
		{ 029e 40		}
		{ 029f 40		}
		{ 02a0 40		}
		{ 02a1 40		}
		{ 02a2 40		}
		{ 02a3 40		}
		{ 02a4 40		}
		{ 02a5 40		}
		{ 02a6 40		}
		{ 02a7 40		}
		{ 02a8 40		}
		{ 02a9 40		}
		{ 02aa 40		}
		{ 02ab 40		}
		{ 02ac 40		}
		{ 02ad 40		}
		{ 02ae 40		}
		{ 02af 40		}
		{ 02b0 40		}
		{ 02b1 40		}
		{ 02b2 40		}
		{ 02b3 40		}
		{ 02b4 d4 01		}
		{ 02b6 20		}
		{ 02b7 17		}
		{ 02b8 40		}
		{ 02b9 40		}
		{ 02ba 40		}
		{ 02bb 40		}
		{ 02bc 40		}
		{ 02bd 40		}
		{ 02be 40		}
		{ 02bf 40		}
		{ 02c0 40		}
		{ 02c1 40		}
		{ 02c2 40		}
		{ 02c3 40		}
		{ 02c4 40		}
		{ 02c5 40		}
		{ 02c6 40		}
		{ 02c7 40		}
		{ 02c8 40		}
		{ 02c9 40		}
		{ 02ca 40		}
		{ 02cb 40		}
		{ 02cc 40		}
		{ 02cd 40		}
		{ 02ce 40		}
		{ 02cf 40		}
		{ 02d0 40		}
		{ 02d1 40		}
		{ 02d2 40		}
		{ 02d3 40		}
		{ 02d4 40		}

		{ 02d5 0c 04 2a		}
		{ 02d8 18 07		}
		{ 02da 17		}
		{ 02db 20		}
		{ 02dc c1		}
		{ 02dd c2		}
		{ 02de cc 04 2a		}
		{ 02e1 0f 04 27		}
		{ 02e4 ef 04 29		}
		{ 02e7 14		}
		{ 02e8 0f 24 13		}
		{ 02eb cf 04 27		}
		{ 02ee e4 20		}
		{ 02f0 18 63		}
		{ 02f2 3f 02 46		}
		{ 02f5 04 0f		}
		{ 02f7 d2		}
		{ 02f8 d2		}
		{ 02f9 d2		}
		{ 02fa d2		}
		{ 02fb 42		}
		{ 02fc d1		}
		{ 02fd d1		}
		{ 02fe d1		}
		{ 02ff d1		}
		{ 0300 45 f0		}
		{ 0302 46 f0		}
		{ 0304 61		}
		{ 0305 c1		}
		{ 0306 03		}
		{ 0307 62		}
		{ 0308 c2		}
		{ 0309 04 01		}
		{ 030b cc 04 2a		}
		{ 030e 1b 51		}

		{ 0310 3b 49		}
		{ 0312 3f 00 a4		}
		{ 0315 3b 44		}
		{ 0317 86 01		}
		{ 0319 77 08		}
		{ 031b 85 00		}
		{ 031d 75 08		}
		{ 031f cd 04 0f		}
		{ 0322 ce 04 10		}
		{ 0325 3b 38		}
		{ 0327 04 ff		}
		{ 0329 cc 04 29		}
		{ 032c 3f 00 8a		}
		{ 032f 04 3a		}
		{ 0331 3f 02 b4		}
		{ 0334 20		}
		{ 0335 cc 04 2c		}
		{ 0338 0d 04 0f		}
		{ 033b 0e 04 10		}
		{ 033e ae 04 0e		}
		{ 0341 77 08		}
		{ 0343 ad 04 0d		}
		{ 0346 75 08		}
		{ 0348 1e 00 1d		}
		{ 034b 19 1c		}
		{ 034d 5a 1c		}
		{ 034f 07 04		}
		{ 0351 3f 02 69		}
		{ 0354 fb 7b		}
		{ 0356 3b 07		}
		{ 0358 1f 00 22		}

		{ 035b 07 03		}
		{ 035d 1b 02		}
		{ 035f 07 32		}
		{ 0361 04 20		}
		{ 0363 3f 02 b4		}
		{ 0366 fb 79		}
		{ 0368 17		}

		{ 0369 06 ff		}
		{ 036b ce 04 28		}
		{ 036e 0d 04 0d		}
		{ 0371 3f 02 69		}
		{ 0374 0d 04 0e		}
		{ 0377 3f 02 69		}
		{ 037a 0d 04 28		}
		{ 037d 3f 02 69		}
		{ 0380 0d 04 2c		}
		{ 0383 3f 02 69		}
		{ 0386 0f 04 29		}
		{ 0389 0f a4 0d		}
		{ 038c ef 04 28		}
		{ 038f 18 09		}
		{ 0391 cf 04 29		}
		{ 0394 c1		}
		{ 0395 3f 02 69		}
		{ 0398 1b 6c		}
		{ 039a 0d 04 2c		}
		{ 039d 3f 02 69		}
		{ 03a0 0e 04 0e		}
		{ 03a3 8e 04 28		}
		{ 03a6 05 00		}
		{ 03a8 77 08		}
		{ 03aa 8d 04 0d		}
		{ 03ad 75 08		}
		{ 03af 3f 00 a4		}
		{ 03b2 1f 03 25		}

		{ 03b5 3f 02 86		}
		{ 03b8 e4 3a		}
		{ 03ba 98 79		}
		{ 03bc 20		}
		{ 03bd cc 04 2c		}
		{ 03c0 3f 02 24		}
		{ 03c3 cd 04 0d		}
		{ 03c6 3f 02 24		}
		{ 03c9 cd 04 0e		}
		{ 03cc 3f 02 24		}
		{ 03cf 59 03		}
		{ 03d1 1f 84 0d		}
		{ 03d4 cd 04 28		}
		{ 03d7 3f 02 24		}
		{ 03da 0c 04 2c		}
		{ 03dd 9c 00 1d		}
		{ 03e0 c3		}
		{ 03e1 cf 04 29		}
		{ 03e4 3f 02 24		}
		{ 03e7 0f 04 29		}
		{ 03ea ef 04 28		}
		{ 03ed 18 06		}
		{ 03ef 01		}
		{ 03f0 cf e4 0d		}
		{ 03f3 db 6c		}
		{ 03f5 0c 04 2c		}
		{ 03f8 9c 00 1d		}
		{ 03fb 1f 03 b5		}
		{ 03fe 40		}
		{ 03ff 40		}
	}

#==============================================================================
