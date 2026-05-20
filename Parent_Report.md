### 1. Çfarë shfaq ekrani

1. App bar me kthim mbrapa:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L57)  
Snippet: "appBar: const CosmicTopBar(showBackButton: true)"

2. Pull-to-refresh për të dhënat javore:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L58)  
Snippet: "body: RefreshIndicator("

3. Header me ikonë + titull + numër fëmijësh:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L104)  
Snippet: "'${family.children.length} fëmijë'"

4. Seksion javor me state machine (loading/error/loaded):
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L143)  
Snippet: "class _WeeklySection extends StatelessWidget"

5. Grafik pikësh ditorë (Bar Chart) me fl_chart:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L1)  
Snippet: "import 'package:fl_chart/fl_chart.dart';"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L441)  
Snippet: "child: BarChart("

6. Grafik trendi saktësie (Line Chart) me fl_chart:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L570)  
Snippet: "child: LineChart("

7. Kartë "Aktiviteti i Fundit":
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L164)  
Snippet: "class _RecentActivitySection extends StatelessWidget"

8. Rreshta aktiviteti me datë, pikë, saktësi, sesione:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L252)  
Snippet: "'${stats.totalPoints} pikë'"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L279)  
Snippet: "'${stats.sessionsCount} ses.'"

9. State loading me progress indicator:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L305)  
Snippet: "const CircularProgressIndicator("

10. State pa të dhëna me mascot:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L337)  
Snippet: "const MascotFrame(size: 90)"

11. Kartat per-child me statistika dhe module breakdown:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L707)  
Snippet: "class _ChildReportCard extends StatelessWidget"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L811)  
Snippet: "class _StatChip extends StatelessWidget"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L868)  
Snippet: "class _ModuleRow extends StatelessWidget"

### 2. Burimi i të dhënave

1. family.children dhe numri i fëmijëve:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L52)  
Snippet: "final family = ref.watch(familyProvider).family;"  
Linja: [lib/core/providers/family_provider.dart](lib/core/providers/family_provider.dart#L45)  
Snippet: "final family = FamilyProfileService.loadFamily();"  
Linja: [lib/core/services/family_profile_service.dart](lib/core/services/family_profile_service.dart#L1)  
Snippet: "import 'package:hive_flutter/hive_flutter.dart';"  
Konkluzion: burim lokal Hive.

2. Weekly stats për grafikë dhe aktivitet të fundit:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L53)  
Snippet: "final weeklyState = ref.watch(weeklyStatsProvider);"  
Linja: [lib/core/providers/weekly_stats_provider.dart](lib/core/providers/weekly_stats_provider.dart#L57)  
Snippet: ".read(syncServiceProvider)"  
Linja: [lib/core/providers/weekly_stats_provider.dart](lib/core/providers/weekly_stats_provider.dart#L58)  
Snippet: ".pullWeeklyStats(activeChild.id);"  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L171)  
Snippet: ".orderBy(FirestoreSchema.date, descending: true)"  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L172)  
Snippet: ".limit(7)"  
Konkluzion: burim cloud Firestore për historikun javor.

3. Metrika per-child (totalPoints, totalAccuracy, completedSessions, moduleHistory):
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L755)  
Snippet: "'${child.totalPoints} pikë totale'"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L781)  
Snippet: "child.totalAccuracy.toStringAsFixed(0)"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L774)  
Snippet: "value: '${child.completedSessions}'"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L801)  
Snippet: "...child.moduleHistory.entries.map("  
Konkluzion: këto vijnë nga modeli ChildProfile i mbajtur në familyProvider (Hive lokal).

4. Fallback kur cloud mungon:
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L166)  
Snippet: "if (!_canSync()) return [];"  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L175)  
Snippet: "return snap.docs.map((d) => d.data()).toList();"  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L178)  
Snippet: "return [];"  
Linja: [lib/core/providers/weekly_stats_provider.dart](lib/core/providers/weekly_stats_provider.dart#L50)  
Snippet: "state = const WeeklyStatsLoaded([]);"  
Konkluzion: ka fallback në listë bosh, jo fallback explicit në Hive për weekly history.

### 3. Granulariteti kohor

1. Historik ditor i limituar në 7 ditët e fundit (cloud):
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L172)  
Snippet: ".limit(7)"

2. Renditje kronologjike për paraqitje:
Linja: [lib/core/providers/weekly_stats_provider.dart](lib/core/providers/weekly_stats_provider.dart#L65)  
Snippet: "..sort((a, b) => a.date.compareTo(b.date));"

3. Aktiviteti i fundit shfaq max 5 ditë:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L177)  
Snippet: "stats.length > 5 ? stats.sublist(stats.length - 5) : stats"

4. Aggregate totale pa ndarje kohore në kartat per-child:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L755)  
Snippet: "pikë totale"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L774)  
Snippet: "completedSessions"

5. Formati i çelësit të datës:
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L238)  
Snippet: "yyyy-MM-dd" pattern i ndërtuar me padLeft.

### 4. Aksesi dhe navigimi

1. Si hapet:
Linja: [lib/features/dashboard/presentation/dashboard_screen.dart](lib/features/dashboard/presentation/dashboard_screen.dart#L39)  
Snippet: "_onProfilePressed"  
Linja: [lib/features/dashboard/presentation/dashboard_screen.dart](lib/features/dashboard/presentation/dashboard_screen.dart#L42)  
Snippet: "builder: (_) => const FamilySwitcherScreen()"  
Linja: [lib/features/family/presentation/family_switcher_screen.dart](lib/features/family/presentation/family_switcher_screen.dart#L60)  
Snippet: "label: const Text('Raporti javor')"  
Linja: [lib/features/family/presentation/family_switcher_screen.dart](lib/features/family/presentation/family_switcher_screen.dart#L70)  
Snippet: "builder: (_) => const ParentReportScreen()"

2. PIN para hyrjes:
Linja: [lib/features/family/presentation/family_switcher_screen.dart](lib/features/family/presentation/family_switcher_screen.dart#L65)  
Snippet: "final ok = await ParentPinDialog.verify(context);"  
Linja: [lib/features/family/presentation/parent_pin_dialog.dart](lib/features/family/presentation/parent_pin_dialog.dart#L18)  
Snippet: "if (!FamilyProfileService.hasParentPin) return true;"  
Konkluzion: kërkon PIN vetëm nëse PIN është konfiguruar; ndryshe lejohet hyrja.

3. AuthGate/consent para navigimit:
Linja: [lib/main.dart](lib/main.dart#L32)  
Snippet: "initialRoute: AppRoutes.dashboard"  
Linja: [lib/main.dart](lib/main.dart#L79)  
Snippet: "AppRoutes.dashboard: (_) => const DashboardScreen()"  
Konkluzion: nuk ka AuthGate explicit në rrugën e hapjes së këtij ekrani.  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L26)  
Snippet: "_canSync()"  
Linja: [lib/core/services/firebase_init_service.dart](lib/core/services/firebase_init_service.dart#L6)  
Snippet: "inicializimin e Firebase pas consent-it prindëror"  
Sqarim: consent/auth ndikojnë vetëm te cloud sync, jo te aksesimi i UI së ekranit.

### 5. Izolimi i profilit

1. Weekly charts përdorin vetëm fëmijën aktiv:
Linja: [lib/core/providers/weekly_stats_provider.dart](lib/core/providers/weekly_stats_provider.dart#L48)  
Snippet: "final activeChild = _ref.read(familyProvider).activeChild;"  
Linja: [lib/core/providers/weekly_stats_provider.dart](lib/core/providers/weekly_stats_provider.dart#L58)  
Snippet: "pullWeeklyStats(activeChild.id)"

2. Ekrani njëkohësisht shfaq edhe të gjithë fëmijët në kartat poshtë:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L126)  
Snippet: "...family.children.map("  
Konkluzion: është pamje e kombinuar, jo vetëm për fëmijën aktiv.

3. Kufizimi ndërmjet familjeve në cloud:
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L32)  
Snippet: "state.account.uid"  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L170)  
Snippet: "dailyStatsCollection(uid, childId)"  
Konkluzion: të dhënat namespacohen sipas uid dhe childId.

4. Mbrojtja ndaj prindit tjetër në të njëjtën pajisje:
E paqartë nga kodi: nuk ka mekanizëm të veçantë autorizimi shumë-prindëror në këtë rrugë; ekziston vetëm PIN opsional.

### 6. Boshllëqet dhe todo-t

1. Nuk gjeta TODO/FIXME ose metoda bosh në skedarët kryesorë të këtij flow (parent report, provider-at, modelet, dialogu PIN, sync service, family provider).  
2. U gjet vetëm koment "Loading placeholder", që është etiketë seksioni UI, jo task i hapur:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L291)

### 7. Çështjet e privatësisë

1. Në UI shfaqet pseudonimi i fëmijës (jo emër real i detyrueshëm):
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L746)  
Snippet: "child.pseudonym"

2. Nuk pashë ekspozim email-i të prindit në këtë ekran:
E paqartë nga kodi i këtij ekrani: nuk ka fusha email në parent_report_screen.dart.

3. Nuk shfaqet child.id/uid në UI të ekranit:
Evidencë indirekte: renderohen vetëm pseudonym, points, accuracy, sessions, module breakdown.

4. Logging i identifikuesve në sync layer (risk privatësie):
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L50)  
Snippet: "debugPrint ... ${child.id}"  
Linja: [lib/core/sync/sync_service.dart](lib/core/sync/sync_service.dart#L228)  
Snippet: "debugPrint ... uid: $uid"  
Konkluzion: nuk është shkelje direkte në UI të raportit, por është risk i minimizimit të të dhënave në loge (sidomos në build jo-release ose log capture).

### 8. Cilësia e kodit

1. Rregulli AdaptiveLayout:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L64)  
Snippet: "ResponsivePage"  
Linja: [lib/responsive.dart](lib/responsive.dart#L94)  
Snippet: "AdaptiveLayout.pagePadding(context)"  
Por ka shumë dimensione hardcoded në vetë ekranin:
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L73)  
Snippet: "EdgeInsets.all(10)"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L235)  
Snippet: "width: 80"  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L301)  
Snippet: "EdgeInsets.all(40)"  
Konkluzion: respektohet pjesërisht (page padding), jo plotësisht sipas rregullit "mos hardcode dimensione".

2. GlassPanel për karta:
Po, përdoret gjerësisht.
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L180)  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L300)  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L415)  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L544)  
Linja: [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart#L714)

3. flutter analyze warnings në skedarin:
Kontrolluar me diagnostics për [lib/features/family/presentation/parent_report_screen.dart](lib/features/family/presentation/parent_report_screen.dart): nuk ka errors/warnings.

4. Teste ekzistuese për këtë ekran:
Nuk u gjetën skedarë testesh të dedikuar për këtë ekran në dosjen test (kërkim sipas parent report).
