enum NavigationRoute {
  homeRoute("/home"),
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  registerRoute("/register"),
  planDetailRoute("/planDetail"),
  cashFlowDetail("/cashFlowDetail");

  const NavigationRoute(this.name);
  final String name;
}
