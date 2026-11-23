import React from 'react';
import { SafeAreaView } from 'react-native-safe-area-context';
export const AppShell = ({ children }) => <SafeAreaView style={{ flex: 1 }}>{children}</SafeAreaView>;
