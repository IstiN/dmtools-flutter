import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/atoms/logos/logos.dart';

class LogosPage extends StatelessWidget {
  const LogosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'Wordmark Logo',
          description: 'The DMTools text logo for headers and branding',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      WordmarkLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      const SizedBox(height: 8),
                      const Text('Small'),
                    ],
                  ),
                  Column(
                    children: [
                      WordmarkLogo(
                        size: LogoSize.medium,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      const SizedBox(height: 8),
                      const Text('Medium'),
                    ],
                  ),
                  Column(
                    children: [
                      WordmarkLogo(
                        size: LogoSize.large,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      const SizedBox(height: 8),
                      const Text('Large'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(AppDimensions.spacingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        WordmarkLogo(
                          size: LogoSize.small,
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        const SizedBox(height: 8),
                        const Text('Small', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        WordmarkLogo(
                          size: LogoSize.medium,
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        const SizedBox(height: 8),
                        const Text('Medium', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        WordmarkLogo(
                          size: LogoSize.large,
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        const SizedBox(height: 8),
                        const Text('Large', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Combined Logo',
          description: 'Icon and wordmark combined for full branding',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          IconLogo(
                            size: LogoSize.small,
                            isTestMode: true,
                            isDarkMode: false,
                          ),
                          const SizedBox(width: 8),
                          WordmarkLogo(
                            size: LogoSize.small,
                            isTestMode: true,
                            isDarkMode: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Small'),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconLogo(
                            size: LogoSize.medium,
                            isTestMode: true,
                            isDarkMode: false,
                          ),
                          const SizedBox(width: 8),
                          WordmarkLogo(
                            size: LogoSize.medium,
                            isTestMode: true,
                            isDarkMode: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Medium'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconLogo(
                        size: LogoSize.large,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      const SizedBox(width: 12),
                      WordmarkLogo(
                        size: LogoSize.large,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Large'),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                IconLogo(
                                  size: LogoSize.small,
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                                const SizedBox(width: 8),
                                WordmarkLogo(
                                  size: LogoSize.small,
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Small', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconLogo(
                                  size: LogoSize.medium,
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                                const SizedBox(width: 8),
                                WordmarkLogo(
                                  size: LogoSize.medium,
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Medium', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconLogo(
                              size: LogoSize.large,
                              isTestMode: true,
                              isDarkMode: true,
                            ),
                            const SizedBox(width: 12),
                            WordmarkLogo(
                              size: LogoSize.large,
                              isTestMode: true,
                              isDarkMode: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Large', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Network Nodes Logo',
          description: 'The main logo with network nodes visualization',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      NetworkNodesLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      const SizedBox(height: 8),
                      const Text('Small'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  NetworkNodesLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium'),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            NetworkNodesLogo(
                              size: LogoSize.small,
                              isTestMode: true,
                              isDarkMode: true,
                            ),
                            const SizedBox(height: 8),
                            const Text('Small', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        NetworkNodesLogo(
                          size: LogoSize.medium,
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        const SizedBox(height: 8),
                        const Text('Medium', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 