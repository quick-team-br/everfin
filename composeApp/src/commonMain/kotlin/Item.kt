import kotlinx.serialization.Serializable

@Serializable
data class Item(
    val name: String,
    val value: Int
)