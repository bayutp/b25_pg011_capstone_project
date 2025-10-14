enum NavigationRoute {
  homeRoute("/home"),
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  registerRoute("/register"),
  planDetailRoute("/planDetail"),
  cashFlowDetail("/cashFlowDetail"),
  addTaskRoute("/addTask");

  const NavigationRoute(this.name);
  final String name;
}
