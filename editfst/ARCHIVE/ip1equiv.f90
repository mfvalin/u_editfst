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
	Logical Function ip1equiv(ip1a,ip1b)
	Implicit none
	Integer *8 ip1a,ip1b
	Integer *8 p_int8, ip8a, ip8b, right31_8, one
	Integer p_inta, p_intb, right31, sbit
	Real pa,pb,errtol
	equivalence (p_inta,pa)	
	equivalence (p_intb,pb)	
	
	errtol = 1.0/(2.0**17)        ! erreur tolelre
	p_int8  = Z'80000000'
	right31 = Z'7FFFFFFF'
	right31_8  = right31
	one = 1
	
	ip8a = ishft(ip1a,-31)     ! kind + bit de signe
	ip8b = ishft(ip1b,-31)     ! kind + bit de signe

!        print *,'Debug+ ip1a,ip1b,ip8a,ip8b',ip1a,ip1b,ip8a,ip8b
	if (ip8a .ne. ip8b) then
	   ip1equiv = .false.
	   return
	endif

	sbit = and(ishft(ip1a,-31),one)
	if (sbit .eq. 1) then
	   p_inta = and(ip1a,right31_8)
	   p_intb = and(ip1b,right31_8)
	else
	   p_inta = p_int8 - and(ip1a,right31_8)
	   p_intb = p_int8 - and(ip1b,right31_8)
	   pa = -pa
	   pb = -pb
	endif
!	print *,'Debug+ sbit=',sbit,' pa=',pa,' pb=',pb
!	write(*,777) pa,pb
 777	format('Debug+ pa=',z16.16,' pb=',z16.16) 
	if (pb .eq. 0.) then
	   if (pa .eq. 0.) then
	      ip1equiv = .true.
	   else
	      ip1equiv = .false.
	   endif
	else
	   if (abs(1- pa/pb) .lt. errtol) then
!	      print *,'Debug+ 1- pa/pb=',abs(1- pa/pb),' errtol=',
!     %                 errtol
	      ip1equiv = .true.
	   else
!	      print *,'Debug+ 1- pa/pb=',abs(1- pa/pb),' errtol=',
!     %                 errtol
	      ip1equiv = .false.
	   endif
	endif
	return
	end
      function ip_equiv(ipa8,ipb8) result(is_equiv)
      Implicit none
      Integer *8, intent(IN) :: ipa8,ipb8
      logical :: is_equiv
      real :: pa, pb
      integer :: kinda, kindb, ipa, ipb
      character(len=1) :: string
      real, parameter :: errtol=1.0E-6

!      print *,'DEBUG: matching ',ipa8,ipb8
      is_equiv = .false.
      if(ipa8==ipb8) then !  both IPs equal, definitely equivalent
        is_equiv = .true.
        return
      endif
      ipa = ipa8
      ipb = ipb8
      call convip(ipa,pa,kinda,-1,string,.false.)
      call convip(ipb,pb,kindb,-1,string,.false.)
      if(kinda /= kindb) return   ! different kinds, definitely not equivalent
      if(pa==pb) then
        is_equiv = .true.
        return
      endif
      if (pb /= 0) then
        is_equiv = abs(1- pa/pb) .lt. errtol
      endif
      return
      end
