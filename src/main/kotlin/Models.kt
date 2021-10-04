package hu.otilsoft.catalog.models

import io.swagger.v3.oas.annotations.media.Schema
import java.time.LocalDateTime
import javax.persistence.*


@MappedSuperclass
abstract class AbstractEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @field:Schema(description = "id of the entity", example = "1")
    var id: Long = 0L

    @Version
    @field:Schema(description = "revision of the entity", example = "5")
    val revision: Int = 0

    @Column(insertable = false, updatable = false)
    @field:Schema(description = "time when the entity has been created", type = "string", example = "2021-02-17 22:45:56")
    val created: LocalDateTime = LocalDateTime.now()

    @Column(insertable = false, updatable = false)
    @field:Schema(description = "time when the entity has been updated", type = "string", example = "2021-02-17 22:45:56")
    var updated: LocalDateTime? = null

    var deleted: LocalDateTime? = null
}


@Entity(name = "storage_type")
data class StorageType(
    @field:Schema(description = "name of storage type", example = "DVD")
    var name: String = ""
) : AbstractEntity()


@Entity
data class Genre(
    @field:Schema(description = "name of genre", example = "thriller")
    var name: String = ""
) : AbstractEntity()


@Entity
data class Series(
    var name: String = "",

    @OneToMany(mappedBy = "series", fetch = FetchType.LAZY, cascade = [CascadeType.ALL])
    var games: List<Game> = emptyList(),

    @OneToMany(mappedBy = "series", fetch = FetchType.LAZY, cascade = [CascadeType.ALL])
    var movies: List<Movie> = emptyList(),
) : AbstractEntity()


@Entity
data class Media(var name: String = "") : AbstractEntity()


@Entity
data class Storage(
    var name: String = "",

    @ManyToOne
    @JoinColumn(name = "storage_type_id", referencedColumnName = "id")
    var storageType: StorageType? = null
) : AbstractEntity()


@Entity
data class Movie(
    var name: String = "",

    @Column(name = "original_name")
    var originalName: String? = null,
    var link: String? = null,
    var release: Int? = null,
    var rating: Double? = null,
    var counter: Int = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    var media: Media? = null,

    @Column(name = "media_number")
    var mediaNumber: Int? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var storage: Storage? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var series: Series? = null,

    @Column(name = "series_num")
    var seriesNum: Int? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var genre: Genre? = null
) : AbstractEntity() {
    fun isBelongToSeries() = series != null
}


@Entity
data class Game(
    var name: String = "",
    var counter: Int = 0,
    var rating: Double? = null,
    var release: Int? = null,
    var link: String? = null,

    @ManyToOne
    var media: Media? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var storage: Storage? = null,

    @ManyToOne
    var series: Series? = null,

    @Column(name = "series_num")
    var seriesNum: Int? = null,

    @ManyToOne
    var genre: Genre? = null,

    @Column(name = "long_term")
    var longTerm: Boolean? = null,
    var description: String? = null
) : AbstractEntity() {
    fun isBelongToSeries() = series != null
}
