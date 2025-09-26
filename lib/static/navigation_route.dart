enum NavigationRoute {
  homeRoute("/home"),
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  registerRoute("/register"),
  addCashflow("/addCashflow");

  const NavigationRoute(this.name);
  final String name;
}
