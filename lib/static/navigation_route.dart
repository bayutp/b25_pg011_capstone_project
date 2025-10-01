enum NavigationRoute {
  homeRoute("/home"),
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  registerRoute("/register"),
  planDetail("/planDetail"),
  cashFlowDetail("/cashFlowDetail"),
  profileRoute("/profile");


  const NavigationRoute(this.name);
  final String name;
}
