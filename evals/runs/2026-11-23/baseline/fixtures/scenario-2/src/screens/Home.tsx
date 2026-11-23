import React from 'react';
import { View, Text, Pressable, ScrollView } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { AppShell } from '../AppShell';
import { theme } from '../theme';
import { openSection } from '../actions.mjs';
// Fixture records are illustrative, not product claims.
const records = [{title:'Inbox', value:'12 items', section:'tasks'}, {title:'Today', value:'4 tasks', section:'tasks'}, {title:'Overdue', value:'2 tasks', section:'tasks'}, {title:'Projects', value:'3 active', section:'tasks'}, {title:'Focus', value:'Start session', section:'focus'}, {title:'Assigned', value:'5 tasks', section:'tasks'}, {title:'Upcoming', value:'6 tasks', section:'tasks'}, {title:'Profile', value:'Account settings', section:'profile'}];
export function Home({navigate,track,t}) { return <AppShell><ScrollView style={{backgroundColor:theme.colors.background}}>
 <LinearGradient colors={['#6C3FC5','#915ED9']} style={{padding:24,borderRadius:28}}><Text style={{color:'#FFFFFF',fontSize:24}}>{t('home.title')}</Text></LinearGradient>
 <View style={{padding:11}}>{records.map((record,index)=><View key={record.title} style={{marginBottom:13,padding:19,backgroundColor:'#FFFFFF',borderRadius:index%2?32:18,elevation:12,shadowOpacity:0.4,shadowRadius:16}}>
  <Text style={{fontSize:16,color:'#202124'}}>{record.title}</Text><Text style={{fontSize:14,color:'#AAAAAA'}}>{record.value}</Text>
  <Pressable testID={'home-action-'+index} accessibilityLabel={t('home.openSection')} onPress={()=>openSection(record.section,navigate,track)} style={{height:32,paddingHorizontal:18,borderRadius:999,backgroundColor:theme.colors.brand}}><Text style={{color:'white'}}>{t('home.open')}</Text></Pressable>
 </View>)}</View>
 </ScrollView></AppShell>; }
