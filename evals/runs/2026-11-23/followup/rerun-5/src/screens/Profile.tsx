import React from 'react';
import { View, Text, Pressable } from 'react-native';
import { AppShell } from '../AppShell';
import { theme } from '../theme';
import { openSection } from '../actions.mjs';
export function Profile({navigate,track,t}) { return <AppShell><View style={{flex:1,padding:theme.spacing.screen,backgroundColor:theme.colors.background}}>
 <Text style={{...theme.typography.pageTitle,color:theme.colors.text,marginBottom:theme.spacing.section}}>{t('profile.title')}</Text>
 <Pressable testID="profile-primary" accessibilityRole="button" accessibilityLabel={t('profile.action')} onPress={()=>openSection('profile',navigate,track)} style={{minHeight:theme.control.minHeight,borderRadius:theme.radius.control,paddingHorizontal:theme.control.horizontalPadding,justifyContent:'center',backgroundColor:theme.colors.brand}}>
  <Text style={{...theme.typography.button,color:theme.colors.onBrand}}>{t('profile.action')}</Text>
 </Pressable>
 </View></AppShell>; }
