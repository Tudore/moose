[GlobalParams]
  density = 10800.0          # kg/m^3
  order = SECOND
  family = LAGRANGE
  disp_x = disp_x
  disp_y = disp_y
[]

[Mesh]
  file = 2D-RZ_mesh.e
  displacements = 'disp_x disp_y'
[]

[Problem]
  coord_type = RZ
[]

[Variables]
  [./disp_x]
  [../]

  [./disp_y]
  [../]
[]


[AuxVariables]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_r = disp_x
    disp_z = disp_y
  [../]
[]

[AuxKernels]
  [./stress_zz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zz
    index = 2
    execute_on = timestep
  [../]
[]

[BCs]

# pin particle along symmetry planes
  [./no_disp_x]
    type = DirichletBC
    variable = disp_x
    boundary = xzero
    value = 0.0
  [../]

  [./no_disp_y]
    type = DirichletBC
    variable = disp_y
    boundary = yzero
    value = 0.0
  [../]

# exterior and internal pressures
  [./exterior_pressure_x]
    type = Pressure
    variable = disp_x
    boundary = outer
    component = 0
    factor = 200
  [../]

 [./exterior_pressure_y]
    type = Pressure
    variable = disp_y
    boundary = outer
    component = 1
    factor = 200
  [../]

  [./interior_pressure_x]
    type = Pressure
    variable = disp_x
    boundary = inner
    component = 0
    factor = 100
  [../]

  [./interior_pressure_y]
    type = Pressure
    variable = disp_y
    boundary = inner
    component = 1
    factor = 100
  [../]
[]

[Materials]

 [./fuel_disp]                         # thermal and irradiation creep for UO2 (bison kernel)
    type = Elastic
    block = 1
    disp_r = disp_x
    disp_z = disp_y
    youngs_modulus = 1e10
    poissons_ratio = .345
    thermal_expansion = 0
  [../]

  [./fuel_den]
    type = Density
    block = 1
    disp_r = disp_x
    disp_z = disp_y
  [../]
[]

[Debug]
    show_var_residual_norms = true
[]

[Executioner]
  type = Transient

  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'

  line_search = 'none'

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  nl_rel_tol = 5e-6
  nl_abs_tol = 1e-10
  nl_max_its = 15

  l_tol = 1e-3
  l_max_its = 50

   start_time = 0.0
   end_time = 1
   num_steps = 1000

  dtmax = 5e6
  dtmin = 1
  [./TimeStepper]
    type = AdaptiveDT
    dt = 1
    optimal_iterations = 6
    iteration_window = 0.4
    linear_iteration_ratio = 100
  [../]

  [./Predictor]
    type = SimplePredictor
    scale = 1.0
  [../]

#  [./Quadrature]
#    order = THIRD
#  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
[]

[Output]
  linear_residuals = true
  file_base = 2D-RZ_out
   interval = 1
   output_initial = true
   exodus = true
   postprocessor_csv = false
   perf_log = true
[]
