#! /bin/csh -f

cd $OBJROOT/ocn/obj

#------------------------------------------------------------------------------
# Make dimensions.F
#------------------------------------------------------------------------------

set dimdir = $OBJROOT/ocn/obj/dimensions
mkdir -p $dimdir
set kdm = `cat $CODEROOT/ocn/micom/bld/$OCN_GRID/kdm`
$CASEROOT/Buildconf/micom_dimensions -n $NTASKS_OCN -k $kdm -d $CODEROOT/ocn/micom/bld/$OCN_GRID || exit -1
set recompile = FALSE
cmp -s dimensions.F $dimdir/dimensions.F || set recompile = TRUE
if ($recompile == 'TRUE') then
  mv dimensions.F $dimdir
else
  rm dimensions.F
endif

#------------------------------------------------------------------------------
# Generate micom.input_data_list
#------------------------------------------------------------------------------

if      ($OCN_GRID == gx1v5) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20091216
else if ($OCN_GRID == gx1v6) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20101119
else if ($OCN_GRID == gx3v7) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20110921
else if ( $OCN_GRID == tnx2v1) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20130206
else if ( $OCN_GRID == tnx1.5v1) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20131011
else if ( $OCN_GRID == tnx1v1) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20120120
else if ( $OCN_GRID == tnx0.25v1) then
  setenv INPUTPATH $DIN_LOC_ROOT/ocn/micom/$OCN_GRID/20130930
else
  echo "$0 ERROR: Cannot deal with GRID = $OCN_GRID "
  exit -1
endif

cat > $CASEBUILD/micom.input_data_list << EOF1
grid_file = $INPUTPATH/grid.nc
ncep_landmask_file = $INPUTPATH/land.sfc.gauss.nc
ncep_height_file = $INPUTPATH/hgt.sfc.nc
ice_clim_file = $INPUTPATH/icec_1968-1996.uf
sst_clim_file = $INPUTPATH/skt_1968-1996.uf
sss_clim_file = $INPUTPATH/sss_nodc.dat
tidal_dissipation_file = $INPUTPATH/tidal_dissipation.nc
meridional_transport_index_file = $INPUTPATH/mertraindex.dat
meridional_transport_basin_file = $INPUTPATH/mertraoceans.dat
section_index_file = $INPUTPATH/secindex.dat
EOF1
if ($RUN_TYPE == startup )  then
cat >> $CASEBUILD/micom.input_data_list << EOF1
inicon_file = $INPUTPATH/inicon.nc
EOF1
endif
set tracers = (`echo $MICOM_TRACER_MODULES`)
set rivnutr = (`echo $MICOM_RIVER_NUTRIENTS`)
foreach module ($tracers)
  if ($module == ecosys) then
cat >> $CASEBUILD/micom.input_data_list << EOF1
dust_file = $INPUTPATH/INPDUST_mhw.nc
EOF1
    if ($rivnutr == TRUE) then
cat >> $CASEBUILD/micom.input_data_list << EOF1
river_file = $INPUTPATH/riv_in.txt
EOF1
    endif
  endif
end

#------------------------------------------------------------------------------
# Set namelist variables
#------------------------------------------------------------------------------

# set LIMITS defaults
set BACLIN   = 1800.
set BATROP   = 36.
set MDV2HI   = 2.
set MDV2LO   = .4
set MDV4HI   = 0.
set MDV4LO   = 0.
set MDC2HI   = 5000.e4
set MDC2LO   = 300.e4
set VSC2HI   = .5
set VSC2LO   = .5
set VSC4HI   = 0.
set VSC4LO   = 0.
set CBAR     = 5.
set CB       = .002
set CWBDTS   = 5.e-5
set CWBDLS   = 25.
set MOMMTH   = "'enecon'"
set EITMTH   = "'gm'"
set EDRITP   = "'large scale'"
set BMCMTH   = "'uc'"
set RMPMTH   = "'eitvel'"
set EDWMTH   = "'smooth'"
set EGC      = 1.0
set EGGAM    = 200.
set EGMNDF   = 100.e4
set EGMXDF   = 1500.e4
set EGIDFQ   = 1.
set RI0      = 1.2
set RM0      = 1.2
set CE       = .06
set TRXDAY   = 0.
set SRXDAY   = 0.
set TRXDPT   = 1.
set SRXDPT   = 1.
set TRXLIM   = 1.5
set SRXLIM   = .5
set APTFLX   = .false.
set APSFLX   = .false.
set DITFLX   = .false.
set DISFLX   = .false.
set SRXBAL   = .false.
set SRXSRC   = "'CORE'"
set SMTFRC   = .true.
set SPRFAC   = .false.
set RSTFRQ   =  1
set RSTFMT   =  1
set RSTCMP   =  0 
set IOTYPE   =  1 
# set BGCNML defaults
set ATM_CO2  = $CCSM_CO2_PPMV
# set DAIPHY defaults 
set GLB_FNAMETAG = "'hd','hm'"  
set GLB_AVEPERIO =  '1,  30'
set GLB_FILEFREQ = '30,  30'
set GLB_COMPFLAG =  '0,   0'
set GLB_NCFORMAT =  '0,   0'
set SRF_ABSWND   =  '0,   2'
set SRF_ALB      =  '0,   0'
set SRF_BRNFLX   =  '0,   2'
set SRF_BRNPD    =  '0,   2'
set SRF_DFL      =  '0,   0'
set SRF_EVA      =  '0,   2'
set SRF_FICE     =  '0,   2'
set SRF_FMLTFZ   =  '0,   2'
set SRF_HICE     =  '0,   0'
set SRF_HMLTFZ   =  '0,   2'
set SRF_HSNW     =  '0,   0'
set SRF_IAGE     =  '0,   0'
set SRF_LIP      =  '0,   2'
set SRF_MAXMLD   =  '4,   2'
set SRF_MLD      =  '0,   2'
set SRF_MLDU     =  '0,   0'
set SRF_MLDV     =  '0,   0'
set SRF_MTY      =  '0,   2'
set SRF_MXLU     =  '0,   2'
set SRF_MXLV     =  '0,   2'
set SRF_NSF      =  '0,   2'
set SRF_RFIFLX   =  '0,   2'
set SRF_RNFFLX   =  '0,   2'
set SRF_SALFLX   =  '0,   2'
set SRF_SALRLX   =  '0,   2'
set SRF_SEALV    =  '4,   2'
set SRF_SFL      =  '0,   2'
set SRF_SOP      =  '0,   2'
set SRF_SIGMX    =  '0,   2'
set SRF_SSS      =  '0,   2'
set SRF_SST      =  '4,   2'
set SRF_SURFLX   =  '0,   2'
set SRF_SURRLX   =  '0,   2'
set SRF_SWA      =  '0,   2'
set SRF_TAUX     =  '0,   2'
set SRF_TAUY     =  '0,   2'
set SRF_TICE     =  '0,   0'
set SRF_TSRF     =  '0,   0'
set SRF_UB       =  '0,   2'
set SRF_UICE     =  '0,   0'
set SRF_USTAR    =  '0,   2'
set SRF_VB       =  '0,   2'
set SRF_VICE     =  '0,   0'
set SRF_ZTX      =  '0,   2'
set LYR_DIAFLX   =  '0,   0'
set LYR_DIFDIA   =  '0,   2'
set LYR_DIFINT   =  '0,   2'
set LYR_DIFISO   =  '0,   2'
set LYR_DP       =  '0,   2'
set LYR_DZ       =  '0,   2'
set LYR_SALN     =  '0,   2'
set LYR_TEMP     =  '0,   2'
set LYR_TRC      =  '0,   0'
set LYR_UFLX     =  '0,   2'
set LYR_UTFLX    =  '0,   2'
set LYR_USFLX    =  '0,   2'
set LYR_UMFLTD   =  '0,   0'
set LYR_UTFLTD   =  '0,   0'
set LYR_UTFLLD   =  '0,   0'
set LYR_USFLTD   =  '0,   0'
set LYR_USFLLD   =  '0,   0'
set LYR_UVEL     =  '0,   2'
set LYR_VFLX     =  '0,   2'
set LYR_VTFLX    =  '0,   2'
set LYR_VSFLX    =  '0,   2'
set LYR_VMFLTD   =  '0,   0'
set LYR_VTFLTD   =  '0,   0'
set LYR_VTFLLD   =  '0,   0'
set LYR_VSFLTD   =  '0,   0'
set LYR_VSFLLD   =  '0,   0'
set LYR_VVEL     =  '0,   2'
set LYR_WFLX     =  '0,   2'
set LYR_WFLX2    =  '0,   2'
set LYR_PV       =  '0,   2'
set LYR_TKE      =  '0,   2'
set LYR_GLS_PSI  =  '0,   2'
set LYR_IDLAGE   =  '0,   2'
set LVL_DIAFLX   =  '0,   0'
set LVL_DIFDIA   =  '0,   2'
set LVL_DIFINT   =  '0,   2'
set LVL_DIFISO   =  '0,   2'
set LVL_DZ       =  '0,   2'
set LVL_SALN     =  '0,   2'
set LVL_TEMP     =  '0,   2'
set LVL_TRC      =  '0,   0'
set LVL_UFLX     =  '0,   2'
set LVL_UTFLX    =  '0,   2'
set LVL_USFLX    =  '0,   2'
set LVL_UMFLTD   =  '0,   0'
set LVL_UTFLTD   =  '0,   0'
set LVL_UTFLLD   =  '0,   0'
set LVL_USFLTD   =  '0,   0'
set LVL_USFLLD   =  '0,   0'
set LVL_UVEL     =  '0,   2'
set LVL_VFLX     =  '0,   2'
set LVL_VTFLX    =  '0,   2'
set LVL_VSFLX    =  '0,   2'
set LVL_VMFLTD   =  '0,   0'
set LVL_VTFLTD   =  '0,   0'
set LVL_VTFLLD   =  '0,   0'
set LVL_VSFLTD   =  '0,   0'
set LVL_VSFLLD   =  '0,   0'
set LVL_VVEL     =  '0,   2'
set LVL_WFLX     =  '0,   2'
set LVL_WFLX2    =  '0,   2'
set LVL_PV       =  '0,   2'
set LVL_TKE      =  '0,   2'
set LVL_GLS_PSI  =  '0,   2'
set LVL_IDLAGE   =  '0,   2'
set MSC_MMFLXL   =  '0,   2'
set MSC_MMFLXD   =  '0,   2'
set MSC_MMFTDL   =  '0,   2'
set MSC_MMFTDD   =  '0,   2'
set MSC_MHFLX    =  '0,   2'
set MSC_MHFTD    =  '0,   2'
set MSC_MHFLD    =  '0,   2'
set MSC_MSFLX    =  '0,   2'
set MSC_MSFTD    =  '0,   2'
set MSC_MSFLD    =  '0,   2'
set MSC_VOLTR    =  '0,   2'
# set DIABGC defaults
set BGC_FNAMETAG  = "'hbgcm','hbgcy'"
set BGC_AVEPERIO  = '30,365'
set BGC_FILEFREQ  = '30,365'
set BGC_COMPFLAG  = '0,   0'
set BGC_NCFORMAT  = '0,   0'
set BGC_INVENTORY = '1,   0'
set SRF_KWCO2     = '2,   2'
set SRF_PCO2      = '2,   2'
set SRF_DMSFLUX   = '2,   2'
set SRF_CO2FXD    = '2,   2'
set SRF_CO2FXU    = '2,   2'
set SRF_OXFLUX    = '2,   2'
set SRF_NIFLUX    = '2,   2'
set SRF_DMS       = '2,   2'
set SRF_DMSPROD   = '2,   2'
set SRF_DMS_BAC   = '2,   2'
set SRF_DMS_UV    = '2,   2'
set SRF_EXPORT    = '2,   2'
set SRF_EXPOSI    = '2,   2'
set SRF_EXPOCA    = '2,   2'
set SRF_ATMCO2    = '2,   2'
set SRF_ATMO2     = '2,   2'
set SRF_ATMN2     = '2,   2'
set LYR_PHYTO     = '2,   0'
set LYR_GRAZER    = '2,   0'
set LYR_DOC       = '2,   0'
set LYR_PHOSY     = '2,   0'
set LYR_PHOSPH    = '2,   0'
set LYR_OXYGEN    = '2,   0'
set LYR_IRON      = '2,   0'
set LYR_ANO3      = '2,   0'
set LYR_ALKALI    = '2,   0'
set LYR_SILICA    = '2,   0'
set LYR_DIC       = '2,   0'
set LYR_POC       = '2,   0'
set LYR_CALC      = '2,   0'
set LYR_OPAL      = '2,   0'
set LYR_CO3       = '2,   0'
set LYR_PH        = '2,   0'
set LYR_OMEGAC    = '2,   0'
set LYR_DIC13     = '2,   0'
set LYR_DIC14     = '2,   0'
set BGC_DP        = '2,   0'
set LYR_NOS       = '2,   0'
set LVL_PHYTO     = '0,   2'
set LVL_GRAZER    = '0,   2'
set LVL_DOC       = '0,   2'
set LVL_PHOSY     = '0,   2'
set LVL_PHOSPH    = '0,   2'
set LVL_OXYGEN    = '0,   2'
set LVL_IRON      = '0,   2'
set LVL_ANO3      = '0,   2'
set LVL_ALKALI    = '0,   2'
set LVL_SILICA    = '0,   2'
set LVL_DIC       = '0,   2'
set LVL_POC       = '0,   2'
set LVL_CALC      = '0,   2'
set LVL_OPAL      = '0,   2'
set LVL_CO3       = '0,   2'
set LVL_PH        = '0,   2'
set LVL_OMEGAC    = '0,   2'
set LVL_DIC13     = '0,   2'
set LVL_DIC14     = '0,   2'
set LVL_NOS       = '0,   2'
set SDM_POWAIC    = '0,   2'
set SDM_POWAAL    = '0,   2'
set SDM_POWAPH    = '0,   2'
set SDM_POWAOX    = '0,   2'
set SDM_POWN2     = '0,   2'
set SDM_POWNO3    = '0,   2'
set SDM_POWASI    = '0,   2'
set SDM_SSSO12    = '0,   2'
set SDM_SSSSIL    = '0,   2'
set SDM_SSSC12    = '0,   2'
set SDM_SSSTER    = '0,   2'


#set IYEAR0   = `echo $RUN_STARTDATE | cut -c1-4  | sed -e 's/^0*//'`
#set IMONTH0  = `echo $RUN_STARTDATE | cut -c6-7  | sed -e 's/^0*//'`
#set IDAY0    = `echo $RUN_STARTDATE | cut -c9-10 | sed -e 's/^0*//'`
set YEAR0   = `echo $RUN_STARTDATE | cut -c1-4 `
set MONTH0  = `echo $RUN_STARTDATE | cut -c6-7 `
set DAY0    = `echo $RUN_STARTDATE | cut -c9-10`

if ($RUN_TYPE == startup || $RUN_TYPE == hybrid )  then
  if ($OCN_NCPL > 1) then 
    echo "$0 ERROR: Unsupported coupling interval OCN_NCPL = $OCN_NCPL "
    exit -1
  else
    @ DAY0 = $DAY0 + 1
    set DAY0=`echo 0$DAY0 | tail -3c`
  endif
endif

if ($MICOM_COUPLING  =~ *partial*) then
  set SPRFAC = .true.
endif

if ($OCN_GRID == gx1v5 || $OCN_GRID == gx1v6) then
  set BACLIN = 1800.
  set BATROP = 36.
else if ($OCN_GRID == gx3v7) then
  set BACLIN = 3600.
  set BATROP = 72.
else if ( $OCN_GRID ==  tnx2v1 || $OCN_GRID ==  tnx1.5v1 ) then
  set BACLIN = 4800.
  set BATROP = 96.
  set EGC    = 0.5
  set EGMXDF = 1000.e4
  set GLB_FNAMETAG = "'hm','hy'"
  set GLB_AVEPERIO = '30, 365'
  set GLB_FILEFREQ = '30, 365'
  set SRF_BRNFLX   =  '0,   0'
  set SRF_BRNPD    =  '0,   0'
  set SRF_FICE     =  '2,   0'
  set SRF_FMLTFZ   =  '0,   0'
  set SRF_HMLTFZ   =  '0,   0'
  set SRF_MAXMLD   =  '2,   0'
  set SRF_MLD      =  '2,   0'
  set SRF_SEALV    =  '2,   2'
  set SRF_SSS      =  '2,   0'
  set SRF_SST      =  '2,   0'
  set SRF_USTAR    =  '0,   0'
  set LYR_DIFDIA   =  '0,   0'
  set LYR_DIFINT   =  '0,   0'
  set LYR_DIFISO   =  '0,   0'
  set LYR_DP       =  '0,   0'
  set LYR_DZ       =  '0,   0'
  set LYR_SALN     =  '0,   0'
  set LYR_TEMP     =  '0,   0'
  set LYR_UVEL     =  '0,   0'
  set LYR_VVEL     =  '0,   0'
  set LYR_WFLX     =  '0,   0'
  set LYR_WFLX2    =  '0,   0'
  set LYR_PV       =  '0,   0'
  set LVL_DIFDIA   =  '0,   0'
  set LVL_DIFINT   =  '0,   0'
  set LVL_DIFISO   =  '0,   0'
  set LVL_DZ       =  '0,   0'
  set LVL_SALN     =  '2,   0'
  set LVL_TEMP     =  '2,   0'
  set LVL_UFLX     =  '0,   0'
  set LVL_UTFLX    =  '0,   0'
  set LVL_USFLX    =  '0,   0'
  set LVL_VFLX     =  '0,   0'
  set LVL_VTFLX    =  '0,   0'
  set LVL_VSFLX    =  '0,   0'
  set LVL_WFLX     =  '0,   2'
  set LVL_WFLX2    =  '0,   0'
  set LVL_PV       =  '0,   0'
else if ( $OCN_GRID ==  tnx1v1) then
  set BACLIN = 3200.
  set BATROP = 64.
else if ( $OCN_GRID ==  tnx0.25v1) then
  set BACLIN = 800.
  set BATROP = 16.
  set MDV2HI = .15
  set MDV2LO = .15
  set VSC2HI = .15
  set VSC2LO = .15
  set VSC4HI = 0.0625
  set VSC4LO = 0.0625
  set MDC2HI = 300.e4
  set CWBDTS = 2.e-4
  set CWBDLS = 50.
  set EDWMTH = "'step'"
  set EGC    = 1.
  set EGMXDF = 1000.e4
  set CE     = .12
  set GLB_NCFORMAT =  '1,   1'
  set BGC_NCFORMAT  = '1,   1'
else
  echo "$0 ERROR: Cannot deal with GRID = $OCN_GRID "
  exit -1
endif

#------------------------------------------------------------------------------
# Create resolved namelist
#------------------------------------------------------------------------------

cat >! $RUNDIR/ocn_in << EOF1
! LIMITS NAMELIST
!
! CONTENTS:
!
! NDAY1    : First day of integration (i)
! NDAY2    : Last day of integration (i)
! IDATE    : Model date in YYYYMMDD (i)
! IDATE0   : Initial experiment date in YYYYMMDD (i)
! RUNID    : Experiment name (a)
! EXPCNF   : Experiment configuration (a)
! BACLIN   : Baroclinic time step (sec) (f)
! BATROP   : Barotropic time step (sec) (f)
! MDV2HI   : Laplacian diffusion velocity for momentum dissipation (cm/s) (f)
! MDV2LO   : Laplacian diffusion velocity for momentum dissipation (cm/s) (f)
! MDV4HI   : Biharmonic diffusion velocity for momentum dissipation (cm/s) (f)
! MDV4LO   : Biharmonic diffusion velocity for momentum dissipation (cm/s) (f)
! MDC2HI   : Laplacian diffusivity for momentum dissipation (cm**2/s) (f)
! MDC2LO   : Laplacian diffusivity for momentum dissipation (cm**2/s) (f)
! VSC2HI   : Parameter in deformation-dependent Laplacian viscosity (f)
! VSC2LO   : Parameter in deformation-dependent Laplacian viscosity (f)
! VSC4HI   : Parameter in deformation-dependent Biharmonic viscosity (f)
! VSC4LO   : Parameter in deformation-dependent Biharmonic viscosity (f)
! CBAR     : rms flow speed for linear bottom friction law (cm/s) (f)
! CB       : Nondiemnsional coefficient of quadratic bottom friction (f)
! CWBDTS   : Coastal wave breaking damping resiprocal time scale (1/s) (f)
! CWBDLS   : Coastal wave breaking damping length scale (m) (f)
! MOMMTH   : Momentum equation discretization method. Valid methods:
!            'enscon' (Sadourny (1975) enstrophy conserving), 'enecon'
!            (Sadourny (1975) energy conserving), 'enedis' (Sadourny
!            (1975) energy conserving with some dissipation) (a)
! EITMTH   : Eddy-induced transport parameterization method. Valid
!            methods: 'intdif', 'gm' (a)
! EDRITP   : Type of Richardson number used in eddy diffusivity
!            computation. Valid types: 'shear', 'large scale' (a)
! BMCMTH   : Baroclinic mass flux correction method. Valid methods:
!            'uc' (upstream column), 'dluc' (depth limited upstream
!            column) (a)
! RMPMTH   : Method of applying eddy-induced transport in the remap
!            transport algorithm. Valid methods: 'eitvel', 'eitflx' (a)
! EDWMTH   : Method to estimate eddy diffusivity weight as a function of
!            the ration of Rossby radius of deformation to the
!            horizontal grid spacing. Valid methods: 'smooth', 'step' (a)
! EGC      : Parameter c in Eden and Greatbatch (2008) parameterization (f)
! EGGAM    : Parameter gamma in E. & G. (2008) param. (f)
! EGMNDF   : Minimum diffusivity in E. & G. (2008) param. (cm**2/s) (f)
! EGMXDF   : Maximum diffusivity in E. & G. (2008) param. (cm**2/s) (f)
! EGIDFQ   : Factor relating the isopycnal diffusivity to the layer
!            interface diffusivity in the Eden and Greatbatch (2008)
!            parameterization. egidfq=difint/difiso () (f)
! RI0      : Critical gradient richardson number for shear driven
!            vertical mixing () (f)
! RM0      : Efficiency factor for wind TKE generation in the Oberhuber
!            (1993) TKE closure () (f)
! CE       : Efficiency factor for the restratification by mixed layer
!            eddies (Fox-Kemper et al., 2008) () (f)
! TRXDAY   : e-folding time scale (days) for SST relax., if 0 no relax. (f)
! SRXDAY   : e-folding time scale (days) for SSS relax., if 0 no relax. (f)
! TRXDPT   : Maximum mixed layer depth for e-folding SST relaxation (m) (f)
! SRXDPT   : Maximum mixed layer depth for e-folding SSS relaxation (m) (f)
! TRXLIM   : Max. absolute value of SST difference in relaxation (degC) (f)
! SRXLIM   : Max. absolute value of SSS difference in relaxation (psu) (f)
! APTFLX   : Apply diagnosed heat flux flag (l)
! APSFLX   : Apply diagnosed freshwater flux flag (l)
! DITFLX   : Diagnose heat flux flag (l)
! DISFLX   : Diagnose freshwater flux flag (l)
! SRXBAL   : Balance the SSS relaxation (l)
! SRXSRC   : SSS climatology used for relax. Valid opts. 'PHC3.0' or 'CORE' (a)
! SMTFRC   : Smooth CESM forcing (l)
! SPRFAC   : Send precipitation/runoff factor to CESM coupler (l)
! PATH     : Path to input files (a)
! PATH1    : Path to diagnostic files (a)
! PATH2    : Path to restart files (a)
! ATM_PATH : Path to synoptic NCEP fields (a)
! RSTFRQ   : Restart frequency in days (30=1month,365=1year) (i)
! RSTFMT   : Format of restart file (valid arguments are 0 for classic,
!            1 for 64-bit offset and 2 for netcdf4/hdf5 format) (i)
! RSTCMP   : Compression flag for restart file (i)
! IOTYPE   : 0 = netcdf, 1 = pnetcdf
&LIMITS
  NDAY1    = 0,
  NDAY2    = 999999,
  IDATE    = ${YEAR0}${MONTH0}${DAY0},
  IDATE0   = ${YEAR0}${MONTH0}${DAY0},
  RUNID    = 'xxxx',
  EXPCNF   = 'cesm',
  BACLIN   = ${BACLIN},
  BATROP   = ${BATROP},
  MDV2HI   = ${MDV2HI},
  MDV2LO   = ${MDV2LO},
  MDV4HI   = ${MDV4HI},
  MDV4LO   = ${MDV4LO},
  MDC2HI   = ${MDC2HI},
  MDC2LO   = ${MDC2LO},
  VSC2HI   = ${VSC2HI},
  VSC2LO   = ${VSC2LO},
  VSC4HI   = ${VSC4HI},
  VSC4LO   = ${VSC4LO},
  CBAR     = ${CBAR},
  CB       = ${CB},
  CWBDTS   = ${CWBDTS},
  CWBDLS   = ${CWBDLS},
  MOMMTH   = ${MOMMTH},
  EITMTH   = ${EITMTH},
  EDRITP   = ${EDRITP},
  BMCMTH   = ${BMCMTH},
  RMPMTH   = ${RMPMTH},
  EDWMTH   = ${EDWMTH},
  EGC      = ${EGC},
  EGGAM    = ${EGGAM},
  EGMNDF   = ${EGMNDF},
  EGMXDF   = ${EGMXDF},
  EGIDFQ   = ${EGIDFQ},
  RI0      = ${RI0},
  RM0      = ${RM0},
  CE       = ${CE},
  TRXDAY   = ${TRXDAY},
  SRXDAY   = ${SRXDAY},
  TRXDPT   = ${TRXDPT},
  SRXDPT   = ${SRXDPT},
  TRXLIM   = ${TRXLIM},
  SRXLIM   = ${SRXLIM},
  APTFLX   = ${APTFLX},
  APSFLX   = ${APSFLX},
  DITFLX   = ${DITFLX},
  DISFLX   = ${DISFLX},
  SRXBAL   = ${SRXBAL},
  SRXSRC   = ${SRXSRC},
  SMTFRC   = ${SMTFRC},
  SPRFAC   = ${SPRFAC},
  PATH     = "${INPUTPATH}/",
  PATH1    = './',
  PATH2    = './',
  ATM_PATH = './',
  RSTFRQ   = ${RSTFRQ},
  RSTFMT   = ${RSTFMT},
  RSTCMP   = ${RSTCMP},
  IOTYPE   = ${IOTYPE}
/

! BGCNML NAMELIST
!
! CONTENTS:
!
! ATM_CO2  : Atmospheric CO2 concentration [ppmv]
&BGCNML
  ATM_CO2  = $CCSM_CO2_PPMV
/

! IO-NAMELIST FOR DIAGNOSTIC OUTPUT
!
! Description:
!   Micom supports multiple output groups for its diagnostic output.
!   Each output group is represented by one column in the namlist and may
!   have its own output format, averaging period, and file frequency.
!   The maximum number of output groups is currently limited to 10 but
!   can be changed easily in mod_dia.F.
!
!   The output precision can be choosen on a per-variable basis.
!
!   Multiple time-slices can be written to the same output file
!   provided that no variable is written in packed data format
!   (i.e. as int2 with scale factor and offset).
!
!   Compression of the output (i.e. storage of only wet points)
!   and the file format can be choosen on a per-file basis.
!
!   All time periods are specified in number of days for positive
!   integer values and fraction of day for negative integer values.
!   The length of the actual calendar month is used if 30 is written.
!   The length of the actual calendar year is used if 365 is written.
!   A variable is not written when 0 is specified.
!
! Namelist acronyms:
!   GLB_     - global parameters i.e. valid for entire output group
!   SRF_     - surface variables (includes all 2d fields)
!   LYR_     - 3d fields with sigma layers as vertical coordinate
!   LVL_     - 3d fields with levitus leves as vertical coordinate
!   MSC_     - miscellanous, non-gridded fields
!
! Global parameters:
!   FNAMETAG - tag used in file name (c10) 
!   AVEPERIO - average period in days (i) 
!   FILEFREQ - how often to start a new file in days (i) 
!   COMPFLAG - switch for compressed/uncompressed output (i) 
!   NCFORMAT - netcdf format (valid arguments are 0 for classic,
!              1 for 64-bit offset and 2 for netcdf4/hdf5 format)
!
! Arguments for diagnostic variables:
!   0        - variable is not written
!   2        - variable is written as int2 with scale factor and offset
!   4        - variable is written as real4
!   8        - variable is written as real8
!
! Output variables:
!   ABSWND   - absolute wind speed [m s-1]
!   ALB      - surface albedo []
!   BRNFLX   - brine flux [kg m-2 s-1]
!   BRNPD    - brine plume depth [m]
!   DFL      - non-solar heat flux derivative [W m-2 K-1]
!   EVA      - evaporation [kg m-2 s-1]
!   FICE     - ice concentration [%]
!   FMLTFZ   - fresh water flux due to melting/freezing [kg m-2 s-1]
!   HICE     - ice thickness [m]
!   HMLTFZ   - heat flux due to melting/freezing [W m-2]
!   HSNW     - snow depth [m]
!   IAGE     - ice age [d]
!   LIP      - liquid precipitation [kg m-2 s-1]
!   MAXMLD   - maximum mixed layer depth [m]
!   MLD      - mixed layer depth [m]
!   MLDU     - mixed layer depth at u-point [m]
!   MLDV     - mixed layer depth at v-point [m]
!   MTY      - wind stress y-component [N m-2]
!   MXLU     - mixed layer velocity x-component [m s-1]
!   MXLV     - mixed layer velocity y-component [m s-1]
!   NSF      - non-solar heat flux [W m-2]
!   RFIFLX   - frozen runoff [kg m-2 s-1]
!   RNFFLX   - liquid runoff [kg m-2 s-1]
!   SALFLX   - salt flux received by ocean [kg m-2 s-1]
!   SALRLX   - restoring salt flux received by ocean [kg m-2 s-1]
!   SEALV    - sea level [m]
!   SFL      - salt flux [kg m-2 s-1]
!   SOP      - solid precipitation [kg m-2 s-1]
!   SIGMX    - mixed layer density [kg m-3]
!   SSS      - ocean surface salinity [g kg-1]
!   SST      - ocean surface temperature [degC]
!   SURFLX   - heat flux received by ocean [W m-2]
!   SURRLX   - restoring heat flux received by ocean [W m-2]
!   SWA      - short-wave heat flux [W m-2]
!   TAUX     - momentum flux received by ocean x-component [N m-2]
!   TAUY     - momentum flux received by ocean y-component [N m-2]
!   TICE     - ice temperature [degC]
!   TSRF     - surface temperature [degC]
!   UB       - barotropic velocity x-component [m s-1]
!   UICE     - ice velocity x-component [m s-1]
!   USTAR    - friction velocity [m s-1]
!   VB       - barotropic velocity y-component [m s-1]
!   VICE     - ice velocity y-component [m s-1]
!   ZTX      - wind stress x-component [N m-2]
!   DIAFLX   - diapycnal volume flux [m s-1]
!   DIFDIA   - diapycnal diffusivity [log10(m2 s-1)]
!   DIFINT   - layer interface diffusivity [log10(m2 s-1)]
!   DIFISO   - isopycnal diffusivity [log10(m2 s-1)]
!   DP       - layer pressure thickness [Pa]
!   DZ       - layer thickness [m]
!   SALN     - salinity [g kg-1]
!   TEMP     - temperature [degC]
!   TRC      - tracer []
!   UFLX     - mass flux in x-direction [kg s-1]
!   UTFLX    - heat flux in x-direction [W]
!   USFLX    - salt flux in x-direction [kg s-1]
!   UMFLTD   - mass flux due to thickness diffusion in x-direction [kg s-1]
!   UTFLTD   - heat flux due to thickness diffusion in x-direction [W]
!   UTFLLD   - heat flux due to lateral diffusion in x-direction [W]
!   USFLTD   - salt flux due to thickness diffusion in x-direction [kg s-1]
!   USFLLD   - salt flux due to lateral diffusion in x-direction [kg s-1]
!   UVEL     - velocity x-component [m s-1]
!   VFLX     - mass flux in y-direction [kg s-1]
!   VTFLX    - heat flux in y-direction [W]
!   VSFLX    - salt flux in y-direction [kg s-1]
!   VMFLTD   - mass flux due to thickness diffusion in y-direction [kg s-1]
!   VTFLTD   - heat flux due to thickness diffusion in y-direction [W]
!   VTFLLD   - heat flux due to lateral diffusion in y-direction [W]
!   VSFLTD   - salt flux due to thickness diffusion in y-direction [kg s-1]
!   VSFLLD   - salt flux due to lateral diffusion in y-direction [kg s-1]
!   VVEL     - velocity x-component [m s-1]
!   WFLX     - vertical mass flux [kg s-1]
!   WFLX2    - vertical mass flux squared [kg2 s-2]
!   PV       - potential vorticity [m-1 s-1]
!   TKE      - turbulent kinetic energy [m2 s-2]
!   GLS_PSI  - generic length scale [m2 s-3]
!   IDLAGE   - ideal age [year]
!   MMFLXL   - meridional overturning circ. (MOC) on isopycnic layers [kg s-1]
!   MMFLXD   - MOC on z-levels [kg s-1]
!   MMFTDL   - MOC due to thickness diffusion on isopycnic layers [kg s-1]
!   MMFTDD   - MOC due to thickness diffusion on z-levels [kg s-1]
!   MHFLX    - meridional heat flux [W]
!   MHFTD    - meridional heat flux due to thickness diffusion [W]
!   MHFLD    - meridional heat flux due to lateral diffusion [W]
!   MSFLX    - meridional salt flux [kg s-1]
!   MSFTD    - meridional salt flux due to thickness diffusion [kg s-1]
!   MSFLD    - meridional salt flux due to lateral diffusion [kg s-1]
!   VOLTR    - section transports [kg s-1]
!
&DIAPHY
  GLB_FNAMETAG = ${GLB_FNAMETAG}, 
  GLB_AVEPERIO = ${GLB_AVEPERIO},
  GLB_FILEFREQ = ${GLB_FILEFREQ},
  GLB_COMPFLAG = ${GLB_COMPFLAG},
  GLB_NCFORMAT = ${GLB_NCFORMAT},
  SRF_ABSWND   = ${SRF_ABSWND},
  SRF_ALB      = ${SRF_ALB},
  SRF_BRNFLX   = ${SRF_BRNFLX},
  SRF_BRNPD    = ${SRF_BRNPD},
  SRF_DFL      = ${SRF_DFL},
  SRF_EVA      = ${SRF_EVA},
  SRF_FICE     = ${SRF_FICE},
  SRF_FMLTFZ   = ${SRF_FMLTFZ},
  SRF_HICE     = ${SRF_HICE},
  SRF_HMLTFZ   = ${SRF_HMLTFZ},
  SRF_HSNW     = ${SRF_HSNW},
  SRF_IAGE     = ${SRF_IAGE},
  SRF_LIP      = ${SRF_LIP},
  SRF_MAXMLD   = ${SRF_MAXMLD},
  SRF_MLD      = ${SRF_MLD},
  SRF_MLDU     = ${SRF_MLDU},
  SRF_MLDV     = ${SRF_MLDV},
  SRF_MTY      = ${SRF_MTY},
  SRF_MXLU     = ${SRF_MXLU},
  SRF_MXLV     = ${SRF_MXLV},
  SRF_NSF      = ${SRF_NSF},
  SRF_RFIFLX   = ${SRF_RFIFLX},
  SRF_RNFFLX   = ${SRF_RNFFLX},
  SRF_SALFLX   = ${SRF_SALFLX},
  SRF_SALRLX   = ${SRF_SALRLX},
  SRF_SEALV    = ${SRF_SEALV},
  SRF_SFL      = ${SRF_SFL},
  SRF_SOP      = ${SRF_SOP},
  SRF_SIGMX    = ${SRF_SIGMX},
  SRF_SSS      = ${SRF_SSS},
  SRF_SST      = ${SRF_SST},
  SRF_SURFLX   = ${SRF_SURFLX},
  SRF_SURRLX   = ${SRF_SURRLX},
  SRF_SWA      = ${SRF_SWA},
  SRF_TAUX     = ${SRF_TAUX},
  SRF_TAUY     = ${SRF_TAUY},
  SRF_TICE     = ${SRF_TICE},
  SRF_TSRF     = ${SRF_TSRF},
  SRF_UB       = ${SRF_UB},
  SRF_UICE     = ${SRF_UICE},
  SRF_USTAR    = ${SRF_USTAR},
  SRF_VB       = ${SRF_VB},
  SRF_VICE     = ${SRF_VICE},
  SRF_ZTX      = ${SRF_ZTX},
  LYR_DIAFLX   = ${LYR_DIAFLX},
  LYR_DIFDIA   = ${LYR_DIFDIA},
  LYR_DIFINT   = ${LYR_DIFINT},
  LYR_DIFISO   = ${LYR_DIFISO},
  LYR_DP       = ${LYR_DP},
  LYR_DZ       = ${LYR_DZ},
  LYR_SALN     = ${LYR_SALN},
  LYR_TEMP     = ${LYR_TEMP},
  LYR_TRC      = ${LYR_TRC},
  LYR_UFLX     = ${LYR_UFLX},
  LYR_UTFLX    = ${LYR_UTFLX},
  LYR_USFLX    = ${LYR_USFLX},
  LYR_UMFLTD   = ${LYR_UMFLTD},
  LYR_UTFLTD   = ${LYR_UTFLTD},
  LYR_UTFLLD   = ${LYR_UTFLLD},
  LYR_USFLTD   = ${LYR_USFLTD},
  LYR_USFLLD   = ${LYR_USFLLD},
  LYR_UVEL     = ${LYR_UVEL},
  LYR_VFLX     = ${LYR_VFLX},
  LYR_VTFLX    = ${LYR_VTFLX},
  LYR_VSFLX    = ${LYR_VSFLX},
  LYR_VMFLTD   = ${LYR_VMFLTD},
  LYR_VTFLTD   = ${LYR_VTFLTD},
  LYR_VTFLLD   = ${LYR_VTFLLD},
  LYR_VSFLTD   = ${LYR_VSFLTD},
  LYR_VSFLLD   = ${LYR_VSFLLD},
  LYR_VVEL     = ${LYR_VVEL},
  LYR_WFLX     = ${LYR_WFLX},
  LYR_WFLX2    = ${LYR_WFLX2},
  LYR_PV       = ${LYR_PV},
  LYR_TKE      = ${LYR_TKE},
  LYR_GLS_PSI  = ${LYR_GLS_PSI},
  LYR_IDLAGE   = ${LYR_IDLAGE},
  LVL_DIAFLX   = ${LVL_DIAFLX},
  LVL_DIFDIA   = ${LVL_DIFDIA},
  LVL_DIFINT   = ${LVL_DIFINT},
  LVL_DIFISO   = ${LVL_DIFISO},
  LVL_DZ       = ${LVL_DZ},
  LVL_SALN     = ${LVL_SALN},
  LVL_TEMP     = ${LVL_TEMP},
  LVL_TRC      = ${LVL_TRC},
  LVL_UFLX     = ${LVL_UFLX},
  LVL_UTFLX    = ${LVL_UTFLX},
  LVL_USFLX    = ${LVL_USFLX},
  LVL_UMFLTD   = ${LVL_UMFLTD},
  LVL_UTFLTD   = ${LVL_UTFLTD},
  LVL_UTFLLD   = ${LVL_UTFLLD},
  LVL_USFLTD   = ${LVL_USFLTD},
  LVL_USFLLD   = ${LVL_USFLLD},
  LVL_UVEL     = ${LVL_UVEL},
  LVL_VFLX     = ${LVL_VFLX},
  LVL_VTFLX    = ${LVL_VTFLX},
  LVL_VSFLX    = ${LVL_VSFLX},
  LVL_VMFLTD   = ${LVL_VMFLTD},
  LVL_VTFLTD   = ${LVL_VTFLTD},
  LVL_VTFLLD   = ${LVL_VTFLLD},
  LVL_VSFLTD   = ${LVL_VSFLTD},
  LVL_VSFLLD   = ${LVL_VSFLLD},
  LVL_VVEL     = ${LVL_VVEL},
  LVL_WFLX     = ${LVL_WFLX},
  LVL_WFLX2    = ${LVL_WFLX2},
  LVL_PV       = ${LVL_PV},
  LVL_TKE      = ${LVL_TKE},
  LVL_GLS_PSI  = ${LVL_GLS_PSI},
  LVL_IDLAGE   = ${LVL_IDLAGE},
  MSC_MMFLXL   = ${MSC_MMFLXL},
  MSC_MMFLXD   = ${MSC_MMFLXD},
  MSC_MMFTDL   = ${MSC_MMFTDL},
  MSC_MMFTDD   = ${MSC_MMFTDD},
  MSC_MHFLX    = ${MSC_MHFLX},
  MSC_MHFTD    = ${MSC_MHFTD},
  MSC_MHFLD    = ${MSC_MHFLD},
  MSC_MSFLX    = ${MSC_MSFLX},
  MSC_MSFTD    = ${MSC_MSFTD},
  MSC_MSFLD    = ${MSC_MSFLD},
  MSC_VOLTR    = ${MSC_VOLTR}
/

!3D HIGH PRIORITY
!   DIC            - Dissolved carbon (dissic) [mol C m-3]
!   ALKALI         - Alkalinity (talk) [eq m-3]
!   PH             - Ph (ph) [-log10([h+])]
!   OXYGEN         - Oxygen (o2) [mol O2 m-3]
!   ANO3           - Nitrate (no3) [mol N m-3]
!   PHOSPH         - Phosphorus (po4) [mol P m-3]
!   IRON           - Dissolved iron (dfe) [mol Fe m-3]
!   SILICA         - Silicate (si) [mol Si m-3]
!
!3D MEDIUM PRIORITY
!   DOC            - Dissolved organic carbon (dissoc) [mol C m-3]
!   PHYTO          - Phytoplankton (phyc) [mol C m-3]
!   GRAZER         - Zooplankton (zooc) [mol C m-3]
!   POC            - Detrius (detoc) [mol C m-3]
!   CALC           - CaCO3 shells (calc) [mol C m-3]
!
!3D LOW PRIORITY
!   PHOSY          - Primary production (pp) [mol C m-3 s-1]
!
!3D NOT REQUESTED
!   OPAL           - Opal shells (opal) [mol Si m-3]
!   CO3            - Carbonate ions (co3) [mol C m-3]
!   OMEGAC         - Saturation state (omegac) [1]
!   DIC13          - Dissolved C13 (dissic13) [mol C m-3]
!   DIC14          - Dissolved C14 (dissic14) [mol C m-3]
!   DP             - Layer thickness (pddpo) [m]
!   NOS            - ???  (nos) [???]
!
!2D HIGH PRIORITY
!   EXPORT         - Export production (epc100) [mol C m-2 s-1]
!   EXPOCA         - Ca export production (epcalc100) [mol Ca m-2 s-1]
!   PCO2           - Surface PCO2 (spco2) [uatm]
!   OXFLUX         - Oxygen flux (fgo2) [mol O2 m-2 s-1]
!   CO2FXD         - Downward CO2 flux (co2fxd) [kg C m-2 s-1]
!   CO2FXU         - Upward CO2 flux (co2fxu) [kg C m-2 s-1]
!
!2D NOT REQUESTED
!   KWCO2          - ??? (kwco2) [???]
!   DMSFLUX        - DMS flux (dmsflux) [mol DMS m-2 s-1]
!   NIFLUX         - Nitrogen flux (fgn2) [mol N2 m-2 s-1]
!   DMSPROD        - DMS production (dmsprod) [???]
!   DMS_BAC        - ??? (dms_bac) [???]
!   DMS_UV         - ??? (dms_uv) [???]
!   EXPOSI         - Si export production (epsi100) [mol Si m-2 s-1]
!   ATMCO2         - Atmospheric CO2 (atmco2) [ppm]
!   ATMO2          - Atmospheric O2 (atmo2) [ppm]
!   ATMN2          - Atmospheric N2 (atmn2) [ppm]
!
!SEDIMENTS
!   POWAIC         - (powdic) [mol C m-3]
!   POWAAL         - (powalk) [eq m-3]
!   POWAPH         - (powpho) [eq m-3]
!   POWAOX         - (powox) [mol O2 m-3]
!   POWN2          - (pown2) [mol N2 m-3]
!   POWNO3         - (powno3)[mol N m-3]
!   POWASI         - (powsi) [mol Si m-3]
!   SSSO12         - (ssso12) [mol m-3]
!   SSSSIL         - (ssssil) [mol Si m-3]
!   SSSC12         - (sssc12) [mol C m-3]
!   SSSTER         - (ssster) [mol m-3]
!
&DIABGC
  GLB_FNAMETAG       = ${BGC_FNAMETAG},
  GLB_AVEPERIO       = ${BGC_AVEPERIO},
  GLB_FILEFREQ       = ${BGC_FILEFREQ},
  GLB_COMPFLAG       = ${BGC_COMPFLAG},
  GLB_NCFORMAT       = ${BGC_NCFORMAT},
  GLB_INVENTORY      = ${BGC_INVENTORY},
  SRF_KWCO2          = ${SRF_KWCO2},
  SRF_PCO2           = ${SRF_PCO2},
  SRF_DMSFLUX        = ${SRF_DMSFLUX},
  SRF_CO2FXD         = ${SRF_CO2FXD},
  SRF_CO2FXU         = ${SRF_CO2FXU},
  SRF_OXFLUX         = ${SRF_OXFLUX},
  SRF_NIFLUX         = ${SRF_NIFLUX},
  SRF_DMS            = ${SRF_DMS},
  SRF_DMSPROD        = ${SRF_DMSPROD},
  SRF_DMS_BAC        = ${SRF_DMS_BAC},
  SRF_DMS_UV         = ${SRF_DMS_UV},
  SRF_EXPORT         = ${SRF_EXPORT},
  SRF_EXPOSI         = ${SRF_EXPOSI},
  SRF_EXPOCA         = ${SRF_EXPOCA},
  SRF_ATMCO2         = ${SRF_ATMCO2},
  SRF_ATMO2          = ${SRF_ATMO2},
  SRF_ATMN2          = ${SRF_ATMN2},
  LYR_PHYTO          = ${LYR_PHYTO},
  LYR_GRAZER         = ${LYR_GRAZER},
  LYR_DOC            = ${LYR_DOC},
  LYR_PHOSY          = ${LYR_PHOSY},
  LYR_PHOSPH         = ${LYR_PHOSPH},
  LYR_OXYGEN         = ${LYR_OXYGEN},
  LYR_IRON           = ${LYR_IRON},
  LYR_ANO3           = ${LYR_ANO3},
  LYR_ALKALI         = ${LYR_ALKALI},
  LYR_SILICA         = ${LYR_SILICA},
  LYR_DIC            = ${LYR_DIC},
  LYR_POC            = ${LYR_POC},
  LYR_CALC           = ${LYR_CALC},
  LYR_OPAL           = ${LYR_OPAL},
  LYR_CO3            = ${LYR_CO3},
  LYR_PH             = ${LYR_PH},
  LYR_OMEGAC         = ${LYR_OMEGAC},
  LYR_DIC13          = ${LYR_DIC13},
  LYR_DIC14          = ${LYR_DIC14},
  LYR_DP             = ${BGC_DP},
  LYR_NOS            = ${LYR_NOS},
  LVL_PHYTO          = ${LVL_PHYTO},
  LVL_GRAZER         = ${LVL_GRAZER},
  LVL_DOC            = ${LVL_DOC},
  LVL_PHOSY          = ${LVL_PHOSY},
  LVL_PHOSPH         = ${LVL_PHOSPH},
  LVL_OXYGEN         = ${LVL_OXYGEN},
  LVL_IRON           = ${LVL_IRON},
  LVL_ANO3           = ${LVL_ANO3},
  LVL_ALKALI         = ${LVL_ALKALI},
  LVL_SILICA         = ${LVL_SILICA},
  LVL_DIC            = ${LVL_DIC},
  LVL_POC            = ${LVL_POC},
  LVL_CALC           = ${LVL_CALC},
  LVL_OPAL           = ${LVL_OPAL},
  LVL_CO3            = ${LVL_CO3},
  LVL_PH             = ${LVL_PH},
  LVL_OMEGAC         = ${LVL_OMEGAC},
  LVL_DIC13          = ${LVL_DIC13},
  LVL_DIC14          = ${LVL_DIC14},
  LVL_NOS            = ${LVL_NOS},
  SDM_POWAIC         = ${SDM_POWAIC},
  SDM_POWAAL         = ${SDM_POWAAL},
  SDM_POWAPH         = ${SDM_POWAPH},
  SDM_POWAOX         = ${SDM_POWAOX},
  SDM_POWN2          = ${SDM_POWN2},
  SDM_POWNO3         = ${SDM_POWNO3},
  SDM_POWASI         = ${SDM_POWASI},
  SDM_SSSO12         = ${SDM_SSSO12},
  SDM_SSSSIL         = ${SDM_SSSSIL},
  SDM_SSSC12         = ${SDM_SSSC12},
  SDM_SSSTER         = ${SDM_SSSTER}
/
EOF1
