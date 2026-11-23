import React from 'react';
import { View, Text, Pressable } from 'react-native';
import { AppShell } from '../AppShell';
import { theme } from '../theme';
import { openSection } from '../actions.mjs';
export function Focus({navigate,track,t}) { return <AppShell><View style={{flex:1,padding:theme.spacing.screen,backgroundColor:theme.colors.background}}>
 <Text style={{fontSize:24,color:theme.colors.text}}>{t('focus.title')}</Text>
 <Pressable testID="focus-primary" accessibilityRole="button" accessibilityLabel={t('focus.action')} onPress={()=>openSection('focus',navigate,track)} style={{minHeight:theme.control.minHeight,borderRadius:theme.radius.control,paddingHorizontal:theme.spacing.controlInline,justifyContent:'center',backgroundColor:theme.colors.brand}}>
  <Text style={{fontSize:16,color:'#FFFFFF'}}>{t('focus.action')}</Text>
 </Pressable>
 </View></AppShell>; }
