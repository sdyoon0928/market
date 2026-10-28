import { StyleSheet, Text, View } from "react-native";

export default function PlannerScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>어떤 여행을 원하세요?</Text>
      <Text style={styles.body}>날짜, 출발지, 이동수단, 관심사를 입력하는 화면이 들어갈 자리입니다.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#F7F4EC", padding: 24 },
  title: { fontSize: 28, fontWeight: "800", color: "#18251F", marginTop: 24 },
  body: { color: "#5D6862", fontSize: 16, lineHeight: 25, marginTop: 16 }
});

