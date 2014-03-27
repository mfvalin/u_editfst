!** S/R REWINDS
!     REWIND LE FICHIER SOURCE AU DEBUT 
      SUBROUTINE REWINDS( DSN, TIPE )
      use configuration
      IMPLICIT NONE 
      INTEGER  DSN(*), TIPE(*)
  
!ARGUMENTS
!  ENTRE    - DSN   - DATASET NAME DU FICHIER A REBOBINER.
!    "      - TIPE  - TYPE DU FICHIER.
!
!AUTEURS
!VERSION ORIGINALE Y. BOURASSA OCT 90
!REVISION 001      "      "    VERSION UNIX
!         002      "      "    MAR 92 ALLEL A LOW2UP POUR TYPE
!         003      "      "    MAI 92 ABORT SI FICHIER INEXISTANT
!         004      "      "     "  "  SKIP ABORT SI EN INTERACTIF 
!         005      M. Lepine   Nov 05 Remplacement de fstabt par qqexit
!
!LANGUAGE   - FTN77 
!
!#include "lin128.cdk"
!#include "maxprms.cdk"
!#include "logiq.cdk"
!#include "desrs.cdk"
!#include "tapes.cdk"
!#include "fiches.cdk"
!#include "char.cdk"
!
!MODULES
      EXTERNAL      ARGDIMS, FSTRWD, OUVRES, LOW2UP, qqexit
!
!*
      INTEGER       ARGDIMS, FSTRWD, I
      CHARACTER*15  T
      CHARACTER*128 DN
  
!     DECODE LE TYPE DE FICHIER (DOIT ETRE SEQ.)
      IF(NP .EQ. 2) THEN
         WRITE(T, LIN128) (TIPE(I), I=1,ARGDIMS(2))
         CALL LOW2UP(T, T)
      ELSE
         T = 'SEQ'
      ENDIF
      IF(INDEX(T,'RND') .EQ. 0) THEN
         SSEQ = .TRUE.
         IF(INDEX(T,'FTN') .GT. 0) THEN
            SNOM = 'STD+SEQ+FTN'
         ELSE
            SNOM = 'STD+SEQ'
         ENDIF
      ELSE
         PRINT*,'PAS DE REWIND POSSIBLE'
         RETURN
      ENDIF

!     DECODE LE NOM DU FICHIER 
      IF(DSN(1) .NE. -1) THEN
         WRITE(DN, LIN128) (DSN(I), I=1,ARGDIMS(1))
         CALL OUVRES( DN )
      ENDIF
      IF( OUVS ) THEN
         I = FSTRWD( SOURCES )
         IF(DEBUG .OR. INTERAC)  WRITE(6,*)' LE FICHIER ',DN,' POSITIONNNE AU DEBUT'
      ELSE
         IF( INTERAC ) THEN
            WRITE(6,*)' LE FICHIER ',DN,' PAS OUVERT'
            RETURN
         ELSE
            CALL qqexit(60)
         ENDIF
      ENDIF

      RETURN
      END 


