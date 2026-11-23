import React from 'react';
import { View, Text, Pressable } from 'react-native';
import { AppShell } from '../AppShell';
import { theme } from '../theme';
import { openSection } from '../actions.mjs';
export function Profile({navigate,track,t}) { return <AppShell><View style={{flex:1,padding:18,backgroundColor:theme.colors.background}}>
 <Text style={{fontSize:24,color:theme.colors.text}}>{t('profile.title')}</Text>
 <Pressable testID="profile-primary" accessibilityRole="button" accessibilityLabel={t('profile.action')} onPress={()=>openSection('profile',navigate,track)} style={{minHeight:46,borderRadius:6,paddingHorizontal:17,justifyContent:'center',backgroundColor:theme.colors.brand}}>
  <Text style={{fontSize:16,color:'#FFFFFF'}}>{t('profile.action')}</Text>
 </Pressable>
 </View></AppShell>; }
