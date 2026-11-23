package evaluation.operations

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextDirection
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp

/** All values in [sampleDashboard] are explicitly preview-only sample data. */
data class Kpi(val label: String, val value: String, val unit: String, val status: String)
data class Alert(val title: String, val detail: String, val actionLabel: String)
data class Trend(val unit: String, val points: List<Float>, val accessibleSummary: String)
data class TimelineEvent(val time: String, val title: String, val detail: String)
data class OperationsUiState(
    val kpis: List<Kpi>, val alerts: List<Alert>, val trend: Trend?,
    val timeline: List<TimelineEvent>, val isSampleData: Boolean,
)

val sampleDashboard = OperationsUiState(
    kpis = listOf(
        Kpi("الطلبات المتأخرة", "12", "طلباً", "مثال — يحتاج متابعة"),
        Kpi("نسبة الإكمال", "96", "%", "مثال — ضمن النطاق"),
        Kpi("قيد المراجعة", "7", "طلبات", "مثال — يحتاج متابعة"),
        Kpi("متوسط زمن المعالجة", "18", "دقيقة", "مثال — ضمن النطاق"),
    ),
    alerts = listOf(Alert("تأخر في معالجة الطلبات", "مثال: توجد 12 طلباً تجاوزت الوقت المستهدف.", "عرض التفاصيل")),
    trend = Trend("طلبات مكتملة", listOf(42f, 51f, 46f, 60f, 57f, 64f, 70f), "مثال: اتجاه الطلبات المكتملة يرتفع من 42 إلى 70 خلال 7 فترات."),
    timeline = listOf(
        TimelineEvent("09:40", "تمت مراجعة طلب", "مثال توضيحي لنشاط تشغيلي."),
        TimelineEvent("09:15", "تم إنشاء تنبيه", "مثال توضيحي لنشاط تشغيلي."),
    ),
    isSampleData = true,
)

@Composable
fun OperationsDashboard(
    state: OperationsUiState,
    onRefresh: () -> Unit,
    onAlertClick: (Alert) -> Unit,
    modifier: Modifier = Modifier,
) = CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
    BoxWithConstraints(modifier = modifier.safeDrawingPadding()) {
        val oneColumn = maxWidth < 360.dp
        Column(
            modifier = Modifier.widthIn(max = 720.dp).fillMaxWidth().align(Alignment.TopCenter)
                .verticalScroll(rememberScrollState()).padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
                Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    Text("لوحة العمليات", style = MaterialTheme.typography.headlineSmall)
                    if (state.isSampleData) Text("بيانات توضيحية فقط — لا تمثل نشاطاً فعلياً", style = MaterialTheme.typography.bodySmall)
                }
                Button(onClick = onRefresh, modifier = Modifier.heightIn(min = 48.dp)) { Text("تحديث") }
            }
            DashboardSection("مؤشرات اليوم") { KpiGrid(state.kpis, oneColumn) }
            if (state.alerts.isNotEmpty()) DashboardSection("تحتاج متابعة") {
                state.alerts.forEach { alert -> AlertCard(alert, onAlertClick) }
            }
            state.trend?.let { trend -> DashboardSection("الأداء خلال 7 فترات — مثال") {
                Text("القيم التالية بيانات توضيحية وليست بيانات تشغيلية.", style = MaterialTheme.typography.bodySmall)
                TrendChart(trend)
            } }
            DashboardSection("آخر النشاطات — مثال") {
                state.timeline.forEach { event -> TimelineRow(event) }
            }
        }
    }
}

@Composable private fun DashboardSection(title: String, content: @Composable () -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Text(title, style = MaterialTheme.typography.titleLarge)
        content()
    }
}

@Composable private fun AlertCard(alert: Alert, onAlertClick: (Alert) -> Unit) {
    Card(colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.errorContainer)) {
        Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Text(alert.title, style = MaterialTheme.typography.titleMedium, color = MaterialTheme.colorScheme.onErrorContainer)
            Text(alert.detail, style = MaterialTheme.typography.bodyMedium, color = MaterialTheme.colorScheme.onErrorContainer)
            Button(onClick = { onAlertClick(alert) }, modifier = Modifier.heightIn(min = 48.dp)) { Text(alert.actionLabel) }
        }
    }
}

@Composable private fun KpiGrid(kpis: List<Kpi>, oneColumn: Boolean) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        kpis.chunked(if (oneColumn) 1 else 2).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(12.dp), modifier = Modifier.fillMaxWidth()) {
                row.forEach { kpi ->
                    Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        Text(kpi.label, style = MaterialTheme.typography.bodyMedium)
                        Text("${kpi.value} ${kpi.unit}", style = MaterialTheme.typography.headlineSmall, textDirection = TextDirection.ContentOrLtr)
                        Text(kpi.status, style = MaterialTheme.typography.bodySmall)
                    }
                }
                if (!oneColumn && row.size == 1) Column(Modifier.weight(1f)) {}
            }
        }
    }
}

@Composable private fun TimelineRow(event: TimelineEvent) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp), modifier = Modifier.fillMaxWidth()) {
        Text(event.time, style = MaterialTheme.typography.labelMedium, textDirection = TextDirection.ContentOrLtr)
        Text(event.title, style = MaterialTheme.typography.titleSmall)
        Text(event.detail, style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable private fun TrendChart(trend: Trend) {
    Canvas(Modifier.fillMaxWidth().height(160.dp).semantics { contentDescription = trend.accessibleSummary }) {
        if (trend.points.size < 2) return@Canvas
        val min = trend.points.minOrNull() ?: return@Canvas
        val max = trend.points.maxOrNull() ?: return@Canvas
        val span = (max - min).takeIf { it > 0f } ?: 1f
        val path = Path()
        trend.points.forEachIndexed { index, point ->
            val x = size.width * index / trend.points.lastIndex.toFloat()
            val y = size.height - ((point - min) / span * size.height)
            if (index == 0) path.moveTo(x, y) else path.lineTo(x, y)
        }
        val blue = androidx.compose.ui.graphics.Color(0xFF175CD3)
        drawPath(path, blue, style = androidx.compose.ui.graphics.drawscope.Stroke(3.dp.toPx()))
        trend.points.forEachIndexed { index, point ->
            val x = size.width * index / trend.points.lastIndex.toFloat()
            val y = size.height - ((point - min) / span * size.height)
            drawCircle(blue, 4.dp.toPx(), Offset(x, y))
        }
    }
}
