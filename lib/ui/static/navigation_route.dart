enum NavigationRoute {
  login('login'),
  register('register'),
  home('home'),
  starterTest('/starter'),
  dailyTest("/daily"),
  result("/result");

  const NavigationRoute(this.name);
  final String name;
}
