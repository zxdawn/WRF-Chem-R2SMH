! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! The Reaction Rates File
! 
! Generated by KPP-2.1 symbolic chemistry Kinetics PreProcessor
!       (http://www.cs.vt.edu/~asandu/Software/KPP)
! KPP is distributed under GPL, the general public licence
!       (http://www.gnu.org/copyleft/gpl.html)
! (C) 1995-1997, V. Damian & A. Sandu, CGRER, Univ. Iowa
! (C) 1997-2005, A. Sandu, Michigan Tech, Virginia Tech
!     With important contributions from:
!        M. Damian, Villanova University, USA
!        R. Sander, Max-Planck Institute for Chemistry, Mainz, Germany
! 
! File                 : radm2_Rates.f90
! Time                 : Sun Sep 21 23:10:55 2014
! Working directory    : /scratch1/lcvalin/RUN/04KM_WRFV3/chem/KPP/mechanisms/radm2
! Equation file        : radm2.kpp
! Output root filename : radm2
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



MODULE radm2_Rates

  USE radm2_Parameters
  USE radm2_Global
  IMPLICIT NONE

CONTAINS



! Begin Rate Law Functions from KPP_HOME/util/UserRateLaws

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!  User-defined Rate Law functions
!  Note: the default argument type for rate laws, as read from the equations file, is single precision
!        but all the internal calculations are performed in double precision
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!~~~>  Arrhenius
   REAL(kind=dp) FUNCTION ARR( A0,B0,C0 )
      REAL A0,B0,C0      
      ARR =  DBLE(A0) * EXP(-DBLE(B0)/TEMP) * (TEMP/300.0_dp)**DBLE(C0)
   END FUNCTION ARR        

!~~~> Simplified Arrhenius, with two arguments
!~~~> Note: The argument B0 has a changed sign when compared to ARR
   REAL(kind=dp) FUNCTION ARR2( A0,B0 )
      REAL A0,B0           
      ARR2 =  DBLE(A0) * EXP( DBLE(B0)/TEMP )              
   END FUNCTION ARR2          

   REAL(kind=dp) FUNCTION EP2(A0,C0,A2,C2,A3,C3)
      REAL A0,C0,A2,C2,A3,C3
      REAL(dp) K0,K2,K3            
      K0 = DBLE(A0) * EXP(-DBLE(C0)/TEMP)
      K2 = DBLE(A2) * EXP(-DBLE(C2)/TEMP)
      K3 = DBLE(A3) * EXP(-DBLE(C3)/TEMP)
      K3 = K3*CFACTOR*1.0E6_dp
      EP2 = K0 + K3/(1.0_dp+K3/K2 )
   END FUNCTION EP2

   REAL(kind=dp) FUNCTION EP3(A1,C1,A2,C2) 
      REAL A1, C1, A2, C2
      REAL(dp) K1, K2      
      K1 = DBLE(A1) * EXP(-DBLE(C1)/TEMP)
      K2 = DBLE(A2) * EXP(-DBLE(C2)/TEMP)
      EP3 = K1 + K2*(1.0E6_dp*CFACTOR)
   END FUNCTION EP3 

   REAL(kind=dp) FUNCTION FALL ( A0,B0,C0,A1,B1,C1,CF)
      REAL A0,B0,C0,A1,B1,C1,CF
      REAL(dp) K0, K1     
      K0 = DBLE(A0) * EXP(-DBLE(B0)/TEMP)* (TEMP/300.0_dp)**DBLE(C0)
      K1 = DBLE(A1) * EXP(-DBLE(B1)/TEMP)* (TEMP/300.0_dp)**DBLE(C1)
      K0 = K0*CFACTOR*1.0E6_dp
      K1 = K0/K1
      FALL = (K0/(1.0_dp+K1))*   &
           DBLE(CF)**(1.0_dp/(1.0_dp+(LOG10(K1))**2))
   END FUNCTION FALL

  !---------------------------------------------------------------------------

  ELEMENTAL REAL(dp) FUNCTION k_3rd(temp,cair,k0_300K,n,kinf_300K,m,fc)

    INTRINSIC LOG10

    REAL(dp), INTENT(IN) :: temp      ! temperature [K]
    REAL(dp), INTENT(IN) :: cair      ! air concentration [molecules/cm3]
    REAL,     INTENT(IN) :: k0_300K   ! low pressure limit at 300 K
    REAL,     INTENT(IN) :: n         ! exponent for low pressure limit
    REAL,     INTENT(IN) :: kinf_300K ! high pressure limit at 300 K
    REAL,     INTENT(IN) :: m         ! exponent for high pressure limit
    REAL,     INTENT(IN) :: fc        ! broadening factor (usually fc=0.6)
    REAL                 :: zt_help, k0_T, kinf_T, k_ratio

    zt_help = 300._dp/temp
    k0_T    = k0_300K   * zt_help**(n) * cair ! k_0   at current T
    kinf_T  = kinf_300K * zt_help**(m)        ! k_inf at current T
    k_ratio = k0_T/kinf_T
    k_3rd   = k0_T/(1._dp+k_ratio)*fc**(1._dp/(1._dp+LOG10(k_ratio)**2))

  END FUNCTION k_3rd

  !---------------------------------------------------------------------------

  ELEMENTAL REAL(dp) FUNCTION k_arr (k_298,tdep,temp)
    ! Arrhenius function

    REAL,     INTENT(IN) :: k_298 ! k at T = 298.15K
    REAL,     INTENT(IN) :: tdep  ! temperature dependence
    REAL(dp), INTENT(IN) :: temp  ! temperature

    INTRINSIC EXP

    k_arr = k_298 * EXP(tdep*(1._dp/temp-3.3540E-3_dp)) ! 1/298.15=3.3540e-3

  END FUNCTION k_arr

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!  End of User-defined Rate Law functions
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

! End Rate Law Functions from KPP_HOME/util/UserRateLaws


! Begin INLINED Rate Law Functions


REAL(KIND=dp) FUNCTION k46( TEMP, C_M )
    REAL(KIND=dp), INTENT(IN) :: temp, c_m
    REAL(KIND=dp) :: k0, k2, k3 

   k0=7.2E-15_dp * EXP(785._dp/TEMP)
   k2=4.1E-16_dp * EXP(1440._dp/TEMP)
   k3=1.9E-33_dp * EXP(725._dp/TEMP)  * C_M

   k46=k0+k3/(1+k3/k2)


END FUNCTION k46




! End INLINED Rate Law Functions

! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Update_SUN - update SUN light using TIME
!   Arguments :
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  SUBROUTINE Update_SUN()
      !USE radm2_Parameters
      !USE radm2_Global

    IMPLICIT NONE

    REAL(kind=dp) SunRise, SunSet
    REAL(kind=dp) Thour, Tlocal, Ttmp 
   
    SunRise = 4.5_dp 
    SunSet  = 19.5_dp 
    Thour = TIME/3600.0_dp 
    Tlocal = Thour - (INT(Thour)/24)*24

    IF ((Tlocal>=SunRise).AND.(Tlocal<=SunSet)) THEN
       Ttmp = (2.0*Tlocal-SunRise-SunSet)/(SunSet-SunRise)
       IF (Ttmp.GT.0) THEN
          Ttmp =  Ttmp*Ttmp
       ELSE
          Ttmp = -Ttmp*Ttmp
       END IF
       SUN = ( 1.0_dp + COS(PI*Ttmp) )/2.0_dp 
    ELSE
       SUN = 0.0_dp 
    END IF

 END SUBROUTINE Update_SUN

! End of Update_SUN function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Update_RCONST - function to update rate constants
!   Arguments :
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Update_RCONST ( )




! Begin INLINED RCONST


! End INLINED RCONST

  RCONST(1) = (j(Pj_no2))
  RCONST(2) = (j(Pj_o31d))
  RCONST(3) = (j(Pj_o33p))
  RCONST(4) = (j(Pj_hno2))
  RCONST(5) = (j(Pj_hno3))
  RCONST(6) = (j(Pj_hno4))
  RCONST(7) = (j(Pj_no3o2))
  RCONST(8) = (j(Pj_no3o))
  RCONST(9) = (j(Pj_h2o2))
  RCONST(10) = (j(Pj_ch2om))
  RCONST(11) = (j(Pj_ch2or))
  RCONST(12) = (j(Pj_ch3cho))
  RCONST(13) = (j(Pj_ch3o2h))
  RCONST(14) = (j(Pj_ch3coch3))
  RCONST(15) = (j(Pj_ch3coo2h))
  RCONST(16) = (j(Pj_ch3coc2h5))
  RCONST(17) = (j(Pj_hcocho))
  RCONST(18) = (j(Pj_hcochob))
  RCONST(19) = (j(Pj_ch3cocho))
  RCONST(20) = (j(Pj_hcochest))
  RCONST(21) = (j(Pj_ch3ono2))
  RCONST(22) = (.20946e0*(C_M*6.00D-34*(TEMP/300.0)**(-2.3)))
  RCONST(23) = (ARR2(6.5D-12,-120.0_dp,TEMP))
  RCONST(24) = (.78084*ARR2(1.8D-11,-110.0_dp,TEMP)+.20946e0*ARR2(3.2D-11,-70.0_dp,TEMP))
  RCONST(25) = (2.2D-10)
  RCONST(26) = (ARR2(2.0D-12,1400.0_dp,TEMP))
  RCONST(27) = (ARR2(1.6D-12,940.0_dp,TEMP))
  RCONST(28) = (ARR2(1.1D-14,500.0_dp,TEMP))
  RCONST(29) = (ARR2(3.7D-12,-240.0_dp,TEMP))
  RCONST(30) = (TROE(1.80D-31,3.2_dp,4.70D-12,1.4_dp,TEMP,C_M))
  RCONST(31) = (TROEE(4.76D26,10900.0_dp,1.80D-31,3.2_dp,4.70D-12,1.4_dp,TEMP,C_M))
  RCONST(32) = ((2.2D-13*EXP(600./TEMP)+1.9D-33*C_M*EXP(980._dp/TEMP)))
  RCONST(33) = ((3.08D-34*EXP(2800._dp/TEMP)+2.66D-54*C_M*EXP(3180._dp/TEMP)))
  RCONST(34) = (ARR2(3.3D-12,200.0_dp,TEMP))
  RCONST(35) = (TROE(7.00D-31,2.6_dp,1.50D-11,0.5_dp,TEMP,C_M))
  RCONST(36) = (.20946e0*ARR2(3.3D-39,-530.0_dp,TEMP))
  RCONST(37) = (ARR2(1.4D-13,2500.0_dp,TEMP))
! RCONST(38) = constant rate coefficient
! RCONST(39) = constant rate coefficient
! RCONST(40) = constant rate coefficient
  RCONST(41) = (ARR2(1.7D-11,-150.0_dp,TEMP))
  RCONST(42) = (ARR2(2.5D-14,1230.0_dp,TEMP))
  RCONST(43) = (2.5D-12)
  RCONST(44) = (TROE(2.20D-30,4.3_dp,1.50D-12,0.5_dp,TEMP,C_M))
  RCONST(45) = (TROEE(9.09D26,11200.0_dp,2.20D-30,4.3_dp,1.50D-12,0.5_dp,TEMP,C_M))
  RCONST(46) = (rc_n2o5)
  RCONST(47) = (TROE(2.60D-30,3.2_dp,2.40D-11,1.3_dp,TEMP,C_M))
  RCONST(48) = (k46(TEMP,C_M))
  RCONST(49) = (ARR2(1.3D-12,-380.0_dp,TEMP))
  RCONST(50) = (ARR2(4.6D-11,-230.0_dp,TEMP))
  RCONST(51) = (TROE(3.00D-31,3.3_dp,1.50D-12,0.0_dp,TEMP,C_M))
  RCONST(52) = ((1.5D-13*(1._dp+2.439D-20*C_M)))
  RCONST(53) = (THERMAL_T2(6.95D-18,1280.0_dp,TEMP))
  RCONST(54) = (THERMAL_T2(1.37D-17,444.0_dp,TEMP))
  RCONST(55) = (ARR2(1.59D-11,540.0_dp,TEMP))
  RCONST(56) = (ARR2(1.73D-11,380.0_dp,TEMP))
  RCONST(57) = (ARR2(3.64D-11,380.0_dp,TEMP))
  RCONST(58) = (ARR2(2.15D-12,-411.0_dp,TEMP))
  RCONST(59) = (ARR2(5.32D-12,-504.0_dp,TEMP))
  RCONST(60) = (ARR2(1.07D-11,-549.0_dp,TEMP))
  RCONST(61) = (ARR2(2.1D-12,-322.0_dp,TEMP))
  RCONST(62) = (ARR2(1.89D-11,-116.0_dp,TEMP))
  RCONST(63) = (4.0D-11)
  RCONST(64) = (9.0D-12)
  RCONST(65) = (ARR2(6.87D-12,-256.0_dp,TEMP))
  RCONST(66) = (ARR2(1.2D-11,745.0_dp,TEMP))
  RCONST(67) = (1.15D-11)
  RCONST(68) = (1.7D-11)
  RCONST(69) = (2.8D-11)
  RCONST(70) = (ARR2(3.8D-12,200.0_dp,TEMP))
  RCONST(71) = (1.0D-11)
  RCONST(72) = (1.0D-11)
  RCONST(73) = (THERMAL_T2(6.85D-18,444.0_dp,TEMP))
  RCONST(74) = (ARR2(1.55D-11,540.0_dp,TEMP))
  RCONST(75) = (ARR2(2.55D-11,-409.0_dp,TEMP))
  RCONST(76) = (ARR2(2.8D-12,-181.0_dp,TEMP))
  RCONST(77) = (ARR2(1.95D+16,13543.0_dp,TEMP))
  RCONST(78) = (4.7D-12)
  RCONST(79) = (ARR2(1.95D+16,13543.0_dp,TEMP))
  RCONST(80) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(81) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(82) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(83) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(84) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(85) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(86) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(87) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(88) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(89) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(90) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(91) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(92) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(93) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(94) = (ARR2(6.0D-13,2058.0_dp,TEMP))
  RCONST(95) = (ARR2(1.4D-12,1900.0_dp,TEMP))
  RCONST(96) = (ARR2(6.0D-13,2058.0_dp,TEMP))
  RCONST(97) = (ARR2(1.4D-12,1900.0_dp,TEMP))
  RCONST(98) = (ARR2(1.4D-12,1900.0_dp,TEMP))
  RCONST(99) = (2.2D-11)
  RCONST(100) = (ARR2(2.0D-12,2923.0_dp,TEMP))
  RCONST(101) = (ARR2(1.0D-11,1895.0_dp,TEMP))
  RCONST(102) = (ARR2(3.23D-11,975.0_dp,TEMP))
  RCONST(103) = (5.81D-13)
  RCONST(104) = (ARR2(1.2D-14,2633.0_dp,TEMP))
  RCONST(105) = (ARR2(1.32D-14,2105.0_dp,TEMP))
  RCONST(106) = (ARR2(7.29D-15,1136.0_dp,TEMP))
  RCONST(107) = (ARR2(1.23D-14,2013.0_dp,TEMP))
  RCONST(108) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(109) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(110) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(111) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(112) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(113) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(114) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(115) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(116) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(117) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(118) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(119) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(120) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(121) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(122) = (ARR2(1.9D-13,-220.0_dp,TEMP))
  RCONST(123) = (ARR2(1.4D-13,-220.0_dp,TEMP))
  RCONST(124) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(125) = (ARR2(3.4D-14,-220.0_dp,TEMP))
  RCONST(126) = (ARR2(2.9D-14,-220.0_dp,TEMP))
  RCONST(127) = (ARR2(1.4D-13,-220.0_dp,TEMP))
  RCONST(128) = (ARR2(1.4D-13,-220.0_dp,TEMP))
  RCONST(129) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(130) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(131) = (ARR2(9.6D-13,-220.0_dp,TEMP))
  RCONST(132) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(133) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(134) = (ARR2(9.6D-13,-220.0_dp,TEMP))
  RCONST(135) = (ARR2(3.4D-13,-220.0_dp,TEMP))
  RCONST(136) = (ARR2(1.0D-13,-220.0_dp,TEMP))
  RCONST(137) = (ARR2(8.4D-14,-220.0_dp,TEMP))
  RCONST(138) = (ARR2(7.2D-14,-220.0_dp,TEMP))
  RCONST(139) = (ARR2(3.4D-13,-220.0_dp,TEMP))
  RCONST(140) = (ARR2(3.4D-13,-220.0_dp,TEMP))
  RCONST(141) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(142) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(143) = (ARR2(1.19D-12,-220.0_dp,TEMP))
  RCONST(144) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(145) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(146) = (ARR2(1.19D-12,-220.0_dp,TEMP))
  RCONST(147) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(148) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(149) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(150) = (ARR2(3.6D-16,-220.0_dp,TEMP))
  RCONST(151) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(152) = (ARR2(4.2D-12,-180.0_dp,TEMP))
  RCONST(153) = (ARR2(7.7D-14,-1300.0_dp,TEMP))
  RCONST(154) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(155) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(156) = (ARR2(3.6D-16,-220.0_dp,TEMP))
  RCONST(157) = (ARR2(1.7D-14,-220.0_dp,TEMP))
  RCONST(158) = (ARR2(4.2D-14,-220.0_dp,TEMP))
  RCONST(159) = (ARR2(3.6D-16,-220.0_dp,TEMP))
      
END SUBROUTINE Update_RCONST

! End of Update_RCONST function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Update_PHOTO - function to update photolytical rate constants
!   Arguments :
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Update_PHOTO ( )


   USE radm2_Global

  RCONST(1) = (j(Pj_no2))
  RCONST(2) = (j(Pj_o31d))
  RCONST(3) = (j(Pj_o33p))
  RCONST(4) = (j(Pj_hno2))
  RCONST(5) = (j(Pj_hno3))
  RCONST(6) = (j(Pj_hno4))
  RCONST(7) = (j(Pj_no3o2))
  RCONST(8) = (j(Pj_no3o))
  RCONST(9) = (j(Pj_h2o2))
  RCONST(10) = (j(Pj_ch2om))
  RCONST(11) = (j(Pj_ch2or))
  RCONST(12) = (j(Pj_ch3cho))
  RCONST(13) = (j(Pj_ch3o2h))
  RCONST(14) = (j(Pj_ch3coch3))
  RCONST(15) = (j(Pj_ch3coo2h))
  RCONST(16) = (j(Pj_ch3coc2h5))
  RCONST(17) = (j(Pj_hcocho))
  RCONST(18) = (j(Pj_hcochob))
  RCONST(19) = (j(Pj_ch3cocho))
  RCONST(20) = (j(Pj_hcochest))
  RCONST(21) = (j(Pj_ch3ono2))
      
END SUBROUTINE Update_PHOTO

! End of Update_PHOTO function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



END MODULE radm2_Rates

