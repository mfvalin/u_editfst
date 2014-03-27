!**S/R CRITSUP DEFIFIT LES CRITERES SUPLEMENTAIRES DE SELECTION
      SUBROUTINE CRITSUP(NI, NJ, NK, GRID, IG1, IG2, IG3, IG4)
      use configuration
      IMPLICIT NONE 
  
      INTEGER     NI, NJ, NK, GRID, IG1, IG2, IG3, IG4
!
!AUTEUR       AUTEUR YVON BOURASSA . JAN 90
!                      "      "      OCT 90 VERSION QLXINS
!Revision 002   M. Lepine - mars 98 - extensions pour fstd98
!Revision 003   M. Lepine - Nov 2002 - passage du bon type d'arguments pour fstcvt
!
!LANGAGE      FTN77 
!
!ARGUMENTS
! ENTRE     - NI,NJ,NK - DIMENSIONS DE LA GRILLE
! ENTRE     - GRID     - TYPE DE GRILLE 
! ENTRE     - IG1@AG4  - DESCRIPTEURS DE LA GRILLE
!
!OBJET(CRITSUP)
!              DEFIFIT DES DETAILS SUR LA GRILLE, ILS SERONT CONSIDERES
!              COMME CLES DE RECHERCHE APPLIQUABLES A TOUS LES DIRECTIVES
!              DESIRE & EXCLURE.
!
! NOTE:        LES DETAILS SERONT AUTOMATIQUEMENT DESACTIVES APRES EXECUTION
!              D'UNE DIRECTIVE SEQCOPI OU STDCOPI.
!
!MODULE
      EXTERNAL FSTCVT
!
!IMPLICITES
!#include "maxprms.cdk"
!#include "desrs.cdk"
!#include "logiq.cdk"
!#include "char.cdk"
!#include "fiches.cdk"
!*
      INTEGER  I, FSTCVT
      CHARACTER*2 TV
      CHARACTER*4 NV
      CHARACTER*12 LBL
  
!     DESACTIVAGE DES CRITERES EN FONCRION
      IG4S = -1
      IG3S = -1
      IG2S = -1
      IG3S = -1
      GTYPS= ' '
      NKS  = -1
      NJS  = -1
      NIS  = -1
  
!     ACTIVAGE DES CRITERES FOURNIS PAR LA DIRECTIVE
      GO TO (8, 7, 6, 5, 4, 3, 2, 1) NP 
    1 IG4S = IG4
    2 IG3S = IG3
    3 IG2S = IG2
    4 IG3S = IG1
!      I = FSTCVT(' ',' ',' ', GRID, NV, TV, LBL, GTYPS, .TRUE.)
    5 I = FSTCVT(-1, -1, -1, GRID, NV, TV, LBL, GTYPS, .TRUE.)
    6 NKS  = NK
    7 NJS  = NJ
    8 NIS  = NI
  
!     DESACTIVER LES CRITERES SUPLEMENTAIRES AVEC "CTITSUP(-1)"
      IF(NP.EQ.1 .AND. NI.EQ.-1) THEN
         SCRI = .FALSE.
         IF( DEBUG ) PRINT*,'CRITERES SUPLEMENTAIRES DESACTIVES'
      ELSE
         IF( DEBUG ) THEN
            IF( SCRI ) THEN
               PRINT*,'CRITERES SUPLEMENTAIRES DE SELECTION MODIFIES' 
            ELSE
               PRINT*,'CRITERES SUPLEMENTAIRES DE SELECTION ACTIVES'
            ENDIF
         ENDIF
         SCRI = .TRUE.
      ENDIF
  
      RETURN
      END 