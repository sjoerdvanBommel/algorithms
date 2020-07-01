import 'package:algorithms/components/tutorials/Node.dart';
import 'package:algorithms/components/tutorials/TutorialStep.dart';
import 'package:algorithms/enums/pathfinding_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DijkstraTutorial extends StatefulWidget {
  final PathfindingAlgorithm algorithm;

  DijkstraTutorial(this.algorithm);

  @override
  _DijkstraTutorialState createState() => _DijkstraTutorialState();
}

class _DijkstraTutorialState extends State<DijkstraTutorial> {
  String startId;
  int step = 0;
  Map<String, int> distances;

  setStartId(String id) {
    if (step == 0) {
      setState(() {
        this.startId = id;
        this.step++;
      });
    }
  }

  @override
  void initState() {
    resetDistances();
    super.initState();
  }

  resetDistances() {
    distances = {
      'A': 1 << 32,
      'B': 1 << 32,
      'C': 1 << 32,
      'D': 1 << 32,
      'E': 1 << 32,
      'F': 1 << 32
    };
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: widget.algorithm.tutorial,
      flags: YoutubePlayerFlags(autoPlay: true),
    );

    final List<TutorialStep> steps = [
      // Step 1
      TutorialStep(
        explanation: 'Pick a starting node by pressing it',
        function: () {
          startId = null;
        },
      ),
      // Step 2
      TutorialStep(
        explanation: 'From now on, {startId} will be the starting node',
        selected: (id) => startId == id,
        function: () => resetDistances(),
      ),
      // Step 3
      TutorialStep(
        explanation:
            'The distance to {startId} will be set to 0, since we\'re already there',
        distanceSelected: (id) => startId == id,
        function: () => distances[startId] = 0,
      ),
      // Step 4
      TutorialStep(
        explanation:
            '{startId} will be marked as visited, because we already know the shortest path to this node',
        selected: (id) => startId == id,
        distanceSelected: (id) => startId == id,
      ),
    ];

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.algorithm.label + ' (${step + 1}/${steps.length})',
              style: Theme.of(context).textTheme.headline5,
            ),
            GestureDetector(
              child: Text(
                'Tutorial',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  child: SimpleDialog(
                    contentPadding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.zero,
                    children: <Widget>[
                      YoutubePlayer(
                        controller: _controller,
                        onEnded: (e) {
                          _controller.reset();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          widget.algorithm.description,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Colors.grey),
          textAlign: TextAlign.justify,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: new Stack(
            children: getNodes(steps),
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              iconSize: 36,
              icon: Icon(Icons.arrow_left),
              onPressed: step == 0
                  ? null
                  : () {
                      setState(() {
                        if (step > 0) step--;
                        if (steps[step].function != null)
                          steps[step].function();
                      });
                    },
            ),
            Expanded(
              child: Text(
                steps[step].explanation.replaceAll(
                    '{startId}', startId != null ? startId : 'Unknown'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            IconButton(
              iconSize: 36,
              icon: Icon(Icons.arrow_right),
              onPressed:
                  step == steps.length - 1 || (step == 0 && startId == null)
                      ? null
                      : () {
                          setState(() {
                            if (step < steps.length - 1) step++;
                            if (steps[step].function != null)
                              steps[step].function();
                          });
                        },
            ),
          ],
        )
      ],
    );
  }

  List<Node> getNodes(List<TutorialStep> steps) {
    Node f = getNode('F', distances['F'], 270, 100, [], steps);
    Node e =
        getNode('E', distances['E'], 180, 180, [NodeConnection(f, 2)], steps);
    Node d = getNode('D', distances['D'], 180, 20,
        [NodeConnection(e, 3), NodeConnection(f, 2)], steps);
    Node c =
        getNode('C', distances['C'], 90, 180, [NodeConnection(e, 3)], steps);
    Node b = getNode('B', distances['B'], 90, 20,
        [NodeConnection(c, 1), NodeConnection(d, 4)], steps);
    Node a = getNode('A', distances['A'], 0, 100,
        [NodeConnection(b, 2), NodeConnection(c, 4)], steps);
    return [a, b, c, d, e, f];
  }

  Node getNode(String id, int distance, double left, double top,
      List<NodeConnection> connectedTo, List<TutorialStep> steps) {
    return Node(
        id: id,
        distance: distance,
        left: left,
        top: top,
        connectedTo: connectedTo,
        onPress: (id) => setStartId(id),
        isSelected:
            steps[step].selected != null ? steps[step].selected(id) : false,
        isDistanceSelected: steps[step].distanceSelected != null
            ? steps[step].distanceSelected(id)
            : false);
  }
}
