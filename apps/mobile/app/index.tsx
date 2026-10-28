import { Link } from "expo-router";
import { SafeAreaView, StyleSheet, Text, View } from "react-native";

export default function HomeScreen() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.hero}>
        <Text style={styles.eyebrow}>광주·전남 전통시장 여행</Text>
        <Text style={styles.title}>장날에 맞춰{`\n`}오늘의 길을 만들어요.</Text>
        <Text style={styles.description}>
          시장과 주변 명소를 이동시간까지 고려해 한 번에 추천해 드립니다.
        </Text>
        <Link href="/planner" style={styles.button}>여행 계획 시작하기</Link>
      </View>
      <View style={styles.card}>
        <Text style={styles.cardTitle}>MVP 개발 중</Text>
        <Text style={styles.cardText}>시장 탐색 → 일정 추천 → 저장 흐름부터 구현합니다.</Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#F7F4EC", padding: 24 },
  hero: { flex: 1, justifyContent: "center" },
  eyebrow: { color: "#376859", fontWeight: "700", marginBottom: 16 },
  title: { color: "#18251F", fontSize: 36, fontWeight: "800", lineHeight: 46 },
  description: { color: "#5D6862", fontSize: 16, lineHeight: 25, marginVertical: 24 },
  button: { backgroundColor: "#376859", color: "white", padding: 16, borderRadius: 14, textAlign: "center", fontWeight: "700", overflow: "hidden" },
  card: { backgroundColor: "white", borderRadius: 18, padding: 20, marginBottom: 20 },
  cardTitle: { color: "#18251F", fontWeight: "800", fontSize: 17, marginBottom: 8 },
  cardText: { color: "#6B746F", lineHeight: 21 }
});

