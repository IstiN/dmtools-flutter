import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/atoms/logos/logos.dart';

class LogosPage extends StatelessWidget {
  const LogosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'Wordmark Logo',
          description: 'The DMTools text logo for headers and branding',
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      WordmarkLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                      ),
                      SizedBox(height: 8),
                      Text('Small'),
                    ],
                  ),
                  Column(
                    children: [
                      WordmarkLogo(
                        isTestMode: true,
                      ),
                      SizedBox(height: 8),
                      Text('Medium'),
                    ],
                  ),
                  Column(
                    children: [
                      WordmarkLogo(
                        size: LogoSize.large,
                        isTestMode: true,
                      ),
                      SizedBox(height: 8),
                      Text('Large'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        WordmarkLogo(
                          size: LogoSize.small,
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        SizedBox(height: 8),
                        Text('Small', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        WordmarkLogo(
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        SizedBox(height: 8),
                        Text('Medium', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        WordmarkLogo(
                          size: LogoSize.large,
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        SizedBox(height: 8),
                        Text('Large', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Combined Logo',
          description: 'Icon and wordmark combined for full branding',
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          IconLogo(
                            size: LogoSize.small,
                            isTestMode: true,
                          ),
                          SizedBox(width: 8),
                          WordmarkLogo(
                            size: LogoSize.small,
                            isTestMode: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Small'),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconLogo(
                            isTestMode: true,
                          ),
                          SizedBox(width: 8),
                          WordmarkLogo(
                            isTestMode: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Medium'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconLogo(
                        size: LogoSize.large,
                        isTestMode: true,
                      ),
                      SizedBox(width: 12),
                      WordmarkLogo(
                        size: LogoSize.large,
                        isTestMode: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Large'),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: const Column(
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
                                SizedBox(width: 8),
                                WordmarkLogo(
                                  size: LogoSize.small,
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text('Small', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconLogo(
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                                SizedBox(width: 8),
                                WordmarkLogo(
                                  isTestMode: true,
                                  isDarkMode: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text('Medium', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                            SizedBox(width: 12),
                            WordmarkLogo(
                              size: LogoSize.large,
                              isTestMode: true,
                              isDarkMode: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Large', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Network Nodes Logo',
          description: 'The main logo with network nodes visualization',
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      NetworkNodesLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                      ),
                      SizedBox(height: 8),
                      Text('Small'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  NetworkNodesLogo(
                    isTestMode: true,
                  ),
                  SizedBox(height: 8),
                  Text('Medium'),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: const Column(
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
                            SizedBox(height: 8),
                            Text('Small', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        NetworkNodesLogo(
                          isTestMode: true,
                          isDarkMode: true,
                        ),
                        SizedBox(height: 8),
                        Text('Medium', style: TextStyle(color: Colors.white)),
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