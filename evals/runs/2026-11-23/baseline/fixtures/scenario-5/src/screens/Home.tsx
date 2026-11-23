import React from 'react';
import { View, Text, Pressable } from 'react-native';
import { AppShell } from '../AppShell';
import { theme } from '../theme';
import { openSection } from '../actions.mjs';
export function Home({navigate,track,t}) { return <AppShell><View style={{flex:1,padding:15,backgroundColor:theme.colors.background}}>
 <Text style={{fontSize:24,color:theme.colors.text}}>{t('tasks.title')}</Text>
 <Pressable testID="tasks-primary" accessibilityRole="button" accessibilityLabel={t('tasks.action')} onPress={()=>openSection('tasks',navigate,track)} style={{minHeight:40,borderRadius:14,paddingHorizontal:17,justifyContent:'center',backgroundColor:theme.colors.brand}}>
  <Text style={{fontSize:16,color:'#FFFFFF'}}>{t('tasks.action')}</Text>
 </Pressable>
 </View></AppShell>; }
