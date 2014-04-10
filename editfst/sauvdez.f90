!/* EDITFST - Collection of useful routines in C and FORTRAN
! * Copyright (C) 1975-2014  Environnement Canada
! *
! * This library is free software; you can redistribute it and/or
! * modify it under the terms of the GNU Lesser General Public
! * License as published by the Free Software Foundation,
! * version 2.1 of the License.
! *
! * This library is distributed in the hope that it will be useful,
! * but WITHOUT ANY WARRANTY; without even the implied warranty of
! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! * Lesser General Public License for more details.
! *
! * You should have received a copy of the GNU Lesser General Public
! * License along with this library; if not, write to the
! * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
! * Boston, MA 02111-1307, USA.
! */
!** S/R SAUVDEZ CONTROLE LA PORTEE DES DIRECTIVES APRES COPIE
      SUBROUTINE SAUVDEZ
      use configuration
      IMPLICIT NONE 
!
!AUTEURS
!VERSION ORIGINALE -   Y. BOURASSA NOV 89
!REVISION      001 -   Y. BOURASSA AVR 92 ANULE LE ZAP SI SAUV=0
!
!LANGUAGE   - FTN77 
!
!#include "maxprms.cdk"
!#include "fiches.cdk"
!#include "desrs.cdk"
!#include "char.cdk"
!
!MODULE
      EXTERNAL FSTCVT, ZAP
!
!*
      INTEGER  FSTCVT, I, J, N
!     SI LES DIRECTIVES RESTENT VALIDES
      IF( SAUV .LE. 0) THEN
         NP = 1
         CALL ZAP( -1 )
         IF( SAUV .LT. 0) RETURN  
      ENDIF

    
!     EFFACER TOUTE TRACE DES DESIRE/EXCLURE/CRITSUP INUTILES
!     appeler la routine appropriee des fichiers standard
!     REQ(11,4,NMD)
      NREQ = SAUV
      DO 10 N=SAUV*77+1, 11*4*NMD   ! ca devrait pas etre 44 plutot que 77 ?
         REQ(N,1,1) = 0
   10    CONTINUE
!     REQ(:,:,sauv+1:NMD) = 0       ! forme plus logique ?
      DO 20 N=SAUV*9+1, 8*NMD 
         SUP(N,1) = 0
   20    CONTINUE
!     SUP(:,sauv+1:NMD) = 0         ! forme plus logique ?
      DO 30 N=SAUV+1, NMD
         REQN(N) = 0
         REQE(N) = 0
         REQT(N) = 0
         DO 30 J=1,10
            I = FSTCVT(-1, -1, -1, -1, NOMS(J,N), TYPS(J,N), ETIS(J,N), GTYS(N), .TRUE.)
   30       CONTINUE
!     COMPTER LES EXCLUSIONS QUI RESTENT EN FORCE
      NEXC = 0
      IF(SAUV .GT. 0) THEN
         DO 40 N=1,SAUV
            SATISF(N) = 0
            IF(DESEXC(N) .EQ. 0) NEXC = NEXC + 1
   40       CONTINUE
      ENDIF
  
      RETURN
      END 
