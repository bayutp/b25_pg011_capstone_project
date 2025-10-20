enum NavigationRoute {
  homeRoute("/home"),
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  registerRoute("/register"),
  planDetailRoute("/planDetail"),
  cashFlowDetail("/cashFlowDetail"),
  addTaskRoute("/addTask"),
  profileRoute("/profile"),
  editProfil("/editProfil"),
  addCashflow("/addCashflow"),
  userCheck("/userCheck"),
  forgotPswd("/forgotPswd"),
  notification("/notification"),
  splashRoute("/splashscreen");

  const NavigationRoute(this.name);
  final String name;
}
